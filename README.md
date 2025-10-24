# PG Seminar Presentation Generator (CBME NMC Medical)

An automated tool for generating high-quality seminar presentations for postgraduate medical students, specifically designed for CBME (Competency-Based Medical Education) curriculum under NMC (National Medical Commission) guidelines.

## Features

- **Automated Research**: Fetches data from Wikipedia and PubMed for evidence-based content
- **Multiple Presentation Levels**: Basic, detailed, comprehensive, and high-quality versions
- **Visualization Assets**: Generates charts and diagrams for data representation
- **MCP Server Integration**: Node.js-based server for automated generation
- **Streamlit Web App**: User-friendly web interface for easy access
- **CI/CD Pipeline**: Automated testing and deployment via GitHub Actions

## Project Structure

```
PG Seminar Presentation Generator/
├── generate_presentation.py          # Basic presentation generator
├── generate_presentation_v2.py       # Detailed version
├── generate_presentation_v3.py       # Comprehensive version
├── generate_presentation_final.py    # High-quality version with Lancet integration
├── generate_presentation_lancet.py   # Version with Lancet Commission findings
├── generate_visualizations.py        # Visualization assets generator
├── seminar-generator/                # MCP server for automated generation
│   ├── package.json
│   ├── tsconfig.json
│   └── src/
│       └── index.ts
├── streamlit_app.py                  # Web application
├── requirements.txt                  # Python dependencies
└── README.md
```

## Installation

### Prerequisites

- Python 3.8+
- Node.js 16+
- Git

### Setup

1. Clone the repository:
```bash
git clone https://github.com/hssling/PG_Seminar_Presentation_Generator_CBME_NMC_Medical.git
cd PG_Seminar_Presentation_Generator_CBME_NMC_Medical
```

2. Install Python dependencies:
```bash
pip install -r requirements.txt
```

3. Install Node.js dependencies for MCP server:
```bash
cd seminar-generator
npm install
npm run build
```

## Usage

### Python Scripts

Generate presentations using Python scripts:

```bash
# Basic presentation
python generate_presentation.py

# Detailed presentation
python generate_presentation_v2.py

# Comprehensive presentation
python generate_presentation_v3.py

# High-quality with Lancet integration
python generate_presentation_final.py

# Generate visualizations
python generate_visualizations.py
```

### MCP Server

The MCP server provides automated generation:

```bash
# Start the MCP server
cd seminar-generator
npm start

# Use the tool (via MCP client)
generate_seminar_materials --topic "Social and Cultural Determinants of Health and Disease" --slides 25
```

### Streamlit Web App

Run the web application:

```bash
streamlit run streamlit_app.py
```

Access the app at `http://localhost:8501`

## Features in Detail

### Research Integration

- **Wikipedia API**: Fetches topic summaries for foundational knowledge
- **PubMed API**: Searches and retrieves abstracts from published research articles
- **Evidence-Based Content**: Incorporates real research findings into presentations

### Presentation Levels

1. **Basic**: 10-15 slides with essential content
2. **Detailed**: 20-25 slides with in-depth analysis
3. **Comprehensive**: 30-35 slides with extensive research
4. **High-Quality**: 35+ slides with Lancet Commission integration

### Visualizations

- Life expectancy disparities charts
- Under-5 mortality rates
- Malnutrition statistics
- Social gradient in health
- Cultural determinants impact
- Program effectiveness comparisons

### MCP Server Capabilities

- Automated topic research
- Dynamic content generation
- PPTX creation with evidence-based slides
- Integration with academic databases

## CBME NMC Compliance

This tool is designed to support Competency-Based Medical Education as per NMC guidelines:

- **Evidence-Based Learning**: Incorporates latest research and guidelines
- **Interactive Learning**: Visual assets for better understanding
- **Self-Directed Learning**: Automated generation for independent study
- **Assessment Ready**: Structured content for seminar presentations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- National Medical Commission (NMC) for CBME guidelines
- World Health Organization (WHO) for research data
- PubMed for academic literature access
- The Lancet Commission for health equity insights

## Contact

For questions or support, please open an issue on GitHub or contact the maintainer.

## CI/CD

This project includes GitHub Actions for automated testing and deployment. The pipeline runs on every push and pull request to ensure code quality and functionality.
