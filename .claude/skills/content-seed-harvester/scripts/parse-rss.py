#!/usr/bin/env python3
"""Parse Reddit Atom RSS XML from stdin, output TSV rows."""

import sys
import xml.etree.ElementTree as ET
import html
import re


def strip_html(h):
    text = re.sub(r'<!--.*?-->', '', h, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', ' ', text)
    text = html.unescape(text)
    text = re.sub(r'\s+', ' ', text).strip()
    text = re.sub(r'\s*submitted by\s+/u/\S+\s*\[link\]\s*\[comments\]', '', text)
    return text


def escape_tsv(s):
    return s.replace('\t', ' ').replace('\n', ' ').replace('\r', '')


def main():
    sub = sys.argv[1]
    feed = sys.argv[2]
    data = sys.stdin.read()

    try:
        root = ET.fromstring(data)
    except ET.ParseError:
        sys.exit(0)

    ns = {'atom': 'http://www.w3.org/2005/Atom'}
    entries = root.findall('atom:entry', ns)

    for entry in entries:
        title = entry.find('atom:title', ns)
        author = entry.find('atom:author/atom:name', ns)
        link = entry.find('atom:link', ns)
        updated = entry.find('atom:updated', ns)
        content = entry.find('atom:content', ns)

        title_text = escape_tsv(title.text if title is not None and title.text else '')
        author_text = escape_tsv(author.text if author is not None and author.text else '')
        link_href = link.get('href', '') if link is not None else ''
        date_text = (updated.text or '')[:10] if updated is not None else ''
        body_text = escape_tsv(strip_html(content.text)) if content is not None and content.text else ''

        print(f"{sub}\t{feed}\t{title_text}\t{author_text}\t{link_href}\t{date_text}\t{body_text}")


if __name__ == '__main__':
    main()
