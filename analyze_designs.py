import os
import re

def analyze_html_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract Title
    title_match = re.search(r'<title>(.*?)</title>', content)
    title = title_match.group(1) if title_match else "Unknown Screen"
    
    # Extract Image URLs
    images = re.findall(r'src=["\'](https://.*?)["\']', content)
    
    # Extract Data-alts or Alts
    alts = re.findall(r'alt=["\'](.*?)["\']', content)
    data_alts = re.findall(r'data-alt=["\'](.*?)["\']', content)
    
    # Extract Inputs/Form fields
    inputs = re.findall(r'<input.*?id=["\'](.*?)["\'].*?>', content)
    buttons = re.findall(r'<button.*?>(.*?)</button>', content, re.DOTALL)
    clean_buttons = []
    for btn in buttons:
        # Clean html tags from button text
        text = re.sub(r'<.*?>', '', btn).strip()
        text = re.sub(r'\s+', ' ', text)
        if text:
            clean_buttons.append(text)
            
    # Key layout elements
    has_grid = 'grid' in content
    has_flex = 'flex' in content
    
    # Text contents in headings
    headings = re.findall(r'<h[1-4].*?>(.*?)</h[1-4]>', content, re.DOTALL)
    clean_headings = [re.sub(r'<.*?>', '', h).strip().replace('\n', ' ') for h in headings]
    clean_headings = [h for h in clean_headings if h]
    
    return {
        "title": title,
        "images": list(set(images)),
        "alts": list(set(alts)),
        "data_alts": list(set(data_alts)),
        "inputs": list(set(inputs)),
        "buttons": clean_buttons,
        "headings": clean_headings
    }

def main():
    root_dir = r"D:\Matrimonial App"
    output_lines = ["# Stitch Exported UI Designs Analysis\n", "This document contains a structured analysis of all the HTML design code files exported from Stitch, detailing titles, assets, forms, CTAs, and branding elements to facilitate pixel-perfect Flutter UI implementation.\n"]
    
    for root, dirs, files in os.walk(root_dir):
        if "code.html" in files:
            file_path = os.path.join(root, "code.html")
            folder_name = os.path.basename(root)
            print(f"Analyzing {folder_name}...")
            
            try:
                analysis = analyze_html_file(file_path)
                output_lines.append(f"## 📁 Directory: `{folder_name}`")
                output_lines.append(f"- **Screen Title:** {analysis['title']}")
                
                if analysis['headings']:
                    output_lines.append("- **Key Headings / Texts:**")
                    for h in analysis['headings'][:5]:
                        output_lines.append(f"  - \"{h}\"")
                
                if analysis['inputs']:
                    output_lines.append(f"- **Inputs / Form Fields:** {', '.join(f'`{i}`' for i in analysis['inputs'])}")
                    
                if analysis['buttons']:
                    output_lines.append(f"- **Buttons / Actions:** {', '.join(f'`{b}`' for b in analysis['buttons'])}")
                
                if analysis['images']:
                    output_lines.append("- **Design Image Assets:**")
                    for img in analysis['images']:
                        output_lines.append(f"  - {img}")
                        
                if analysis['data_alts']:
                    output_lines.append("- **Image Context / Visual Description:**")
                    for da in analysis['data_alts']:
                        output_lines.append(f"  - *{da}*")
                
                output_lines.append("\n" + "-" * 40 + "\n")
            except Exception as e:
                print(f"Error reading {file_path}: {e}")
                
    with open(r"C:\Users\NSEIT\.gemini\antigravity\brain\ac4b181b-d043-4cc2-ae0c-7150800d1647\artifacts\design_system_analysis.md", 'w', encoding='utf-8') as f:
        f.write("\n".join(output_lines))
    print("Analysis saved to artifacts!")

if __name__ == "__main__":
    main()
