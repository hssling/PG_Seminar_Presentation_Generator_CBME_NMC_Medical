import streamlit as st
import subprocess
import os
import time

st.title("PG Seminar Presentation Generator")
st.markdown("Automated tool for generating high-quality seminar presentations for CBME NMC Medical curriculum")

# Sidebar for configuration
st.sidebar.header("Configuration")
topic = st.sidebar.text_input("Topic", "Social and Cultural Determinants of Health and Disease")
slides = st.sidebar.slider("Number of Slides", 10, 50, 25)
include_visuals = st.sidebar.checkbox("Include Visualizations", True)
presentation_type = st.sidebar.selectbox(
    "Presentation Type",
    ["Basic", "Detailed", "Comprehensive", "High Quality", "Lancet Integration"]
)

if st.sidebar.button("Generate Presentation"):
    with st.spinner("Generating presentation..."):
        try:
            if presentation_type == "Basic":
                script = "generate_presentation.py"
            elif presentation_type == "Detailed":
                script = "generate_presentation_v2.py"
            elif presentation_type == "Comprehensive":
                script = "generate_presentation_v3.py"
            elif presentation_type == "High Quality":
                script = "generate_presentation_final.py"
            else:
                script = "generate_presentation_lancet.py"

            # Run the Python script
            result = subprocess.run(['python', script], capture_output=True, text=True)

            if result.returncode == 0:
                st.success("Presentation generated successfully!")

                # Find the generated PPTX file
                pptx_files = [f for f in os.listdir() if f.endswith('.pptx') and topic.lower().replace(' ', '_') in f.lower()]
                if pptx_files:
                    pptx_file = pptx_files[0]
                    st.download_button(
                        label="Download Presentation",
                        data=open(pptx_file, 'rb'),
                        file_name=pptx_file,
                        mime='application/vnd.openxmlformats-officedocument.presentationml.presentation'
                    )

                    # Generate visualizations if requested
                    if include_visuals:
                        st.info("Generating visualizations...")
                        vis_result = subprocess.run(['python', 'generate_visualizations.py'], capture_output=True, text=True)
                        if vis_result.returncode == 0:
                            st.success("Visualizations generated!")
                            # Show visualization files
                            png_files = [f for f in os.listdir() if f.endswith('.png')]
                            if png_files:
                                st.subheader("Visualization Assets")
                                for png in png_files[:6]:  # Show first 6
                                    st.image(png, caption=png, width=400)
                else:
                    st.error("No presentation file found. Please check the script output.")
            else:
                st.error(f"Error generating presentation: {result.stderr}")

        except Exception as e:
            st.error(f"An error occurred: {str(e)}")

# Display existing presentations
st.header("Existing Presentations")
pptx_files = [f for f in os.listdir() if f.endswith('.pptx')]
if pptx_files:
    for pptx in pptx_files:
        col1, col2 = st.columns([3, 1])
        with col1:
            st.write(pptx)
        with col2:
            with open(pptx, 'rb') as f:
                st.download_button(
                    label="Download",
                    data=f,
                    file_name=pptx,
                    mime='application/vnd.openxmlformats-officedocument.presentationml.presentation',
                    key=pptx
                )
else:
    st.info("No presentations generated yet. Use the sidebar to create one.")

# Display visualizations
st.header("Visualization Assets")
png_files = [f for f in os.listdir() if f.endswith('.png')]
if png_files:
    cols = st.columns(3)
    for i, png in enumerate(png_files):
        with cols[i % 3]:
            st.image(png, caption=png, width=300)
else:
    st.info("No visualizations available. Generate a presentation with visualizations enabled.")

# MCP Server status
st.header("MCP Server Status")
if os.path.exists('seminar-generator/mcp_server.py'):
    st.success("Python MCP Server is ready")
    st.info("To use the MCP server, run: python seminar-generator/mcp_server.py")
    st.info("The server provides the same functionality as the TypeScript version but in pure Python")
else:
    st.warning("MCP Server file not found. Make sure mcp_server.py exists in seminar-generator directory")

st.markdown("---")
st.markdown("Built for CBME NMC Medical Education | Evidence-based content with research integration")
