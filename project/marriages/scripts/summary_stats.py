# -*- coding: utf-8 -*-
"""
This queries the Internet Archive search API to get a list of documents
in the nycmarriageindex collection and then usses the IIF Manifests to 
provide metadata about each document and generate summary statistics.

The output is a CSV with the form of:

  identifier,page_count,average_image_width,average_image_height,document title

Created on Mon Apr 11 16:10:11 2016

@author: Tom Morris <tfmorris@gmail.com>
"""

from __future__ import print_function
import requests
import sys

COLLECTION = 'nycmarriageindex'
SEARCH_URL = 'https://archive.org/advancedsearch.php'
IIF_BASE = 'https://iiif.archivelab.org/iiif/'

def search(collection_id):
    params = {'q':collection_id,
              'fl[]' : 'identifier,title,mediatype,collection,year,subject',
              'rows' : 100,
              'output' : 'json',
              }
    
    response = requests.get(SEARCH_URL, params)
    
    if not response.ok:
        print('Failed with %d' % response.status_code)
        
    search_results = response.json()

    results = []
    for doc in search_results['response']['docs']:
        if 'mediatype' in doc and doc['mediatype'] == 'texts': # skip favorites
            ident = doc['identifier']
            #year = doc['year'] if 'year' in doc else '' # Some are missing year
            #print('%s %s %s' % (year, ident, doc['title']))
            results.append(ident)
    return results

def process_metadata(ident):
    url = IIF_BASE + ident + '/manifest.json'
    r = requests.get(url)
    if not r.ok:
        print('GET failed with %d %s' % (r.status_code, url))
        return
    meta = r.json()
    #print('Processing %s' % meta['label'])
    
    # We assume a single sequence containing all the pages
    assert len(meta['sequences']) == 1
    canvases = meta['sequences'][0]['canvases']
    count = len(canvases)
    total_w = 0
    total_h = 0
    min_w = sys.maxint
    min_h = sys.maxint
    max_w = -1
    max_h = -1
    for canvas in canvases:
        w = canvas['width']
        h = canvas['height']
        total_w += w
        total_h += h
        min_w = min(w, min_w)
        min_h = min(h, min_h)
        max_w = max(w, max_w)
        max_h = max(h, max_h)
    
    # Compute as integers
    avg_w = total_w / count
    avg_h = total_h / count

    print (','.join([ident, str(count), str(avg_w), str(avg_h), str(min_w), str(max_w), str(min_h), str(max_h), meta['label']]))
    
def main():
    ids = search(COLLECTION)
    for i in sorted(ids):
        process_metadata(i)

if __name__ == '__main__':
    main()