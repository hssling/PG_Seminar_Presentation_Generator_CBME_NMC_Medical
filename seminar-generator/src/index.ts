#!/usr/bin/env node
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import {
  CallToolRequestSchema,
  ErrorCode,
  ListToolsRequestSchema,
  McpError,
} from '@modelcontextprotocol/sdk/types.js';
import axios from 'axios';
import PptxGenJS from 'pptxgenjs';
import { XMLParser } from 'fast-xml-parser';

const isValidGenerateSeminarArgs = (
  args: any
): args is { topic: string; slides?: number; includeVisuals?: boolean } =>
  typeof args === 'object' &&
  args !== null &&
  typeof args.topic === 'string' &&
  (args.slides === undefined || typeof args.slides === 'number') &&
  (args.includeVisuals === undefined || typeof args.includeVisuals === 'boolean');

class SeminarGeneratorServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: 'seminar-generator',
        version: '1.0.0',
      },
      {
        capabilities: {
          tools: {},
        },
      }
    );

    this.setupToolHandlers();

    this.server.onerror = (error) => console.error('[MCP Error]', error);
    process.on('SIGINT', async () => {
      await this.server.close();
      process.exit(0);
    });
  }

  private setupToolHandlers() {
    this.server.setRequestHandler(ListToolsRequestSchema, async () => ({
      tools: [
        {
          name: 'generate_seminar_materials',
          description: 'Generate comprehensive seminar materials including PPTX and visualizations for a given topic',
          inputSchema: {
            type: 'object',
            properties: {
              topic: {
                type: 'string',
                description: 'The topic for the seminar',
              },
              slides: {
                type: 'number',
                description: 'Number of slides (default: 20)',
                minimum: 10,
                maximum: 50,
              },
              includeVisuals: {
                type: 'boolean',
                description: 'Include visualization assets (default: true)',
              },
            },
            required: ['topic'],
          },
        },
      ],
    }));

    this.server.setRequestHandler(CallToolRequestSchema, async (request) => {
      if (request.params.name !== 'generate_seminar_materials') {
        throw new McpError(
          ErrorCode.MethodNotFound,
          `Unknown tool: ${request.params.name}`
        );
      }

      if (!isValidGenerateSeminarArgs(request.params.arguments)) {
        throw new McpError(
          ErrorCode.InvalidParams,
          'Invalid seminar generation arguments'
        );
      }

      const topic = request.params.arguments.topic;
      const slides = request.params.arguments.slides || 20;
      const includeVisuals = request.params.arguments.includeVisuals !== false;

      try {
        const result = await this.generateSeminarMaterials(topic, slides, includeVisuals);
        return {
          content: [
            {
              type: 'text',
              text: result,
            },
          ],
        };
      } catch (error) {
        return {
          content: [
            {
              type: 'text',
              text: `Error generating seminar materials: ${error.message}`,
            },
          ],
          isError: true,
        };
      }
    });
  }

  private async generateSeminarMaterials(topic: string, slides: number, includeVisuals: boolean): Promise<string> {
    // Research the topic
    const researchData = await this.researchTopic(topic);

    // Generate content
    const content = this.generateContent(topic, researchData, slides);

    // Create PPTX
    const pptxPath = await this.createPPTX(topic, content, slides);

    // Generate visualizations if requested
    let visualsPath = '';
    if (includeVisuals) {
      visualsPath = `visualization_${topic.replace(/\s+/g, '_')}.png (use Python script for visuals)`;
    }

    return `Seminar materials generated successfully.\nPPTX: ${pptxPath}\nVisuals: ${visualsPath}`;
  }

  private async researchTopic(topic: string): Promise<string> {
    let research = '';

    // Wikipedia research
    try {
      const wikiResponse = await axios.get(`https://en.wikipedia.org/api/rest_v1/page/summary/${encodeURIComponent(topic)}`, {
        timeout: 10000,
      });
      research += `Wikipedia Summary: ${wikiResponse.data.extract}\n\n`;
    } catch (error) {
      research += 'Wikipedia data not available.\n\n';
    }

    // PubMed literature search
    try {
      const pubmedResponse = await axios.get(`https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=${encodeURIComponent(topic)}&retmax=5`, {
        timeout: 10000,
      });
      const parser = new XMLParser();
      const xmlData = parser.parse(pubmedResponse.data);
      const pmids = xmlData.eSearchResult?.IdList?.Id || [];

      if (pmids.length > 0) {
        research += `Key PubMed Articles:\n`;
        for (const pmid of pmids.slice(0, 3)) {
          try {
            const abstractResponse = await axios.get(`https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=${pmid}&retmode=xml`, {
              timeout: 10000,
            });
            const abstractData = parser.parse(abstractResponse.data);
            const article = abstractData.PubmedArticleSet?.PubmedArticle?.MedlineCitation?.Article;
            const title = article?.ArticleTitle || 'No title';
            const abstract = article?.Abstract?.AbstractText || 'No abstract';
            research += `- ${title}: ${abstract.substring(0, 200)}...\n`;
          } catch (error) {
            research += `- Article ${pmid}: Abstract not available.\n`;
          }
        }
      }
    } catch (error) {
      research += 'PubMed data not available.\n\n';
    }

    return research;
  }

  private generateContent(topic: string, research: string, slides: number): string[] {
    const content = [];

    // Title slide
    content.push(`Title: ${topic}\nSubtitle: Comprehensive Seminar Presentation`);

    // Learning objectives
    content.push(`Learning Objectives:\n- Understand the key concepts of ${topic}\n- Analyze evidence and data\n- Discuss implications and recommendations`);

    // Outline
    content.push(`Outline:\n1. Introduction\n2. Main Content\n3. Evidence\n4. Conclusions\n5. Recommendations`);

    // Introduction
    content.push(`Introduction:\n${research.substring(0, 200)}...`);

    // Main content
    for (let i = 4; i < slides - 4; i++) {
      content.push(`Slide ${i}: ${topic} - Aspect ${i - 3}\nContent based on research.`);
    }

    // Conclusions
    content.push(`Conclusions:\nKey findings on ${topic}.`);

    // Recommendations
    content.push(`Recommendations:\nActionable steps for ${topic}.`);

    return content;
  }

  private async createPPTX(topic: string, content: string[], slides: number): Promise<string> {
    const pptx = new PptxGenJS();

    // Title slide
    const slide1 = pptx.addSlide();
    slide1.addText(topic, { x: 1, y: 1, w: 8, h: 2, fontSize: 44, bold: true });
    slide1.addText('Comprehensive Seminar Presentation', { x: 1, y: 3, w: 8, h: 1, fontSize: 24 });

    // Learning objectives
    const slide2 = pptx.addSlide();
    slide2.addText('Learning Objectives', { x: 1, y: 0.5, w: 8, h: 1, fontSize: 32 });
    slide2.addText(content[1], { x: 1, y: 1.5, w: 8, h: 4, fontSize: 18 });

    // Outline
    const slide3 = pptx.addSlide();
    slide3.addText('Outline', { x: 1, y: 0.5, w: 8, h: 1, fontSize: 32 });
    slide3.addText(content[2], { x: 1, y: 1.5, w: 8, h: 4, fontSize: 18 });

    // Content slides
    for (let i = 3; i < Math.min(content.length, slides - 2); i++) {
      const slide = pptx.addSlide();
      slide.addText(`Slide ${i + 1}`, { x: 1, y: 0.5, w: 8, h: 1, fontSize: 32 });
      slide.addText(content[i], { x: 1, y: 1.5, w: 8, h: 4, fontSize: 18 });
    }

    // Conclusions
    const slideC = pptx.addSlide();
    slideC.addText('Conclusions', { x: 1, y: 0.5, w: 8, h: 1, fontSize: 32 });
    slideC.addText(content[content.length - 2], { x: 1, y: 1.5, w: 8, h: 4, fontSize: 18 });

    // Recommendations
    const slideR = pptx.addSlide();
    slideR.addText('Recommendations', { x: 1, y: 0.5, w: 8, h: 1, fontSize: 32 });
    slideR.addText(content[content.length - 1], { x: 1, y: 1.5, w: 8, h: 4, fontSize: 18 });

    const path = `seminar_${topic.replace(/\s+/g, '_')}.pptx`;
    await pptx.writeFile({ fileName: path });
    return path;
  }

  private async generateVisualizations(topic: string, research: string): Promise<string> {
    // Placeholder for visualizations - use Python script for actual visuals
    const path = `visualization_${topic.replace(/\s+/g, '_')}.png`;
    return path;
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
    console.error('Seminar Generator MCP server running on stdio');
  }
}

const server = new SeminarGeneratorServer();
server.run().catch(console.error);
