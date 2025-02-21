import argparse
import requests
import os
import yaml
import json

def parse_repo_url(url):
    """
    Extracts the 'owner' and 'repo' from a GitHub URL.
    Assumes the URL does not include "https://".
    For example, both 'github.com/owner/repo' and 'owner/repo'
    will return ('owner', 'repo').
    """
    url = url.strip()
    # Remove a leading "github.com/" if present
    if url.startswith("github.com/"):
        url = url[len("github.com/"):]
    parts = url.split('/')
    if len(parts) >= 2:
        return parts[0], parts[1]
    return None, None

def fetch_yaml_from_repo(owner, repo):
    """
    Attempts to fetch the YAML file named '<repo>.yaml' from the repository's root.
    It tries the 'main' branch first and then 'master' if needed.
    Returns a tuple (filename, content) if successful, otherwise None.
    """
    filename = f"{repo}.yaml"
    branches = ["main", "master"]
    
    for branch in branches:
        raw_url = f"https://raw.githubusercontent.com/{owner}/{repo}/{branch}/{filename}"
        response = requests.get(raw_url)
        if response.status_code == 200:
            print(f"Found YAML file at: {raw_url}")
            return filename, response.text
        else:
            print(f"Could not find file at {raw_url} (HTTP {response.status_code}).")
    print(f"YAML file {filename} not found in repository {owner}/{repo}.")
    return None

def main():
    parser = argparse.ArgumentParser(
        description="Download YAML files (named after the repo) from GitHub repositories, parse them, and aggregate into a JSON file."
    )
    parser.add_argument(
        "input_file", 
        help="Path to the text file containing GitHub repository URLs (one per line, e.g., 'github.com/owner/repo' or 'owner/repo')."
    )
    args = parser.parse_args()

    if not os.path.exists(args.input_file):
        print(f"Input file '{args.input_file}' not found.")
        return
    
    with open(args.input_file, "r") as f:
        repo_urls = [line.strip() for line in f if line.strip()]
    
    aggregated_slaves = []  # This list will store the parsed YAML content from each repo

    for url in repo_urls:
        owner, repo = parse_repo_url(url)
        if not owner or not repo:
            print(f"Could not parse repository information from URL: {url}")
            continue

        print(f"Processing repository: {owner}/{repo}")
        result = fetch_yaml_from_repo(owner, repo)
        if result:
            file_name, content = result
            try:
                parsed_yaml = yaml.safe_load(content)
                aggregated_slaves.append(parsed_yaml)
                print(f"Parsed YAML from {owner}/{repo} ({file_name}).")
            except yaml.YAMLError as e:
                print(f"Error parsing YAML from {owner}/{repo} ({file_name}): {e}")
        print("-" * 40)
    
    # Aggregate the parsed YAML into a JSON structure under the key 'slaves'
    aggregated_data = {"slaves": aggregated_slaves}
    
    output_filename = "aggregated_slaves.json"
    with open(output_filename, "w", encoding="utf-8") as out_file:
        json.dump(aggregated_data, out_file, indent=4, default=str)
    
    print(f"\nAggregated JSON file saved as: {output_filename}")

if __name__ == "__main__":
    main()
