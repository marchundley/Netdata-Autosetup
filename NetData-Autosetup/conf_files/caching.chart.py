# -*- coding: utf-8 -*-
# Description: sensors netdata python.d plugin
# Author: GitStoph - adapted from Pawel Krupa (paulfantom), with help from l2isbad

from bases.FrameworkServices.SimpleService import SimpleService
from subprocess import check_output
import json

priority = 65000
retries = 60
# update_every = 3

CACHE_STATS = [
 'CacheUsed',
 'CacheFree',
 'CacheLimit',
 'PersonalCacheUsed',
 'PersonalCacheFree',
 'PersonalCacheLimit',
 'TotalBytesStoredFromOrigin',
 'TotalBytesStoredFromParents',
 'TotalBytesStoredFromPeers',
 'TotalBytesReturnedToChildren',
 'TotalBytesReturnedToClients',
 'TotalBytesReturnedToPeers',
 'Port',
 'RegistrationStatus']

CACHE_DETAILS = [
 'Mac Software',
 'iOS Software',
 'Apple TV Software',
 'Other',
 'iCloud',
 'Books']

ORDER = ['cache_storage', 'cache_content', 'cache_served', 'cache_status', 'cache_port']

# This is a prototype of chart definition which is used to dynamically create self.definitions
CHARTS = {
    'cache_storage': {
        'options': [None, 'Caching HDD Use', 'Gigabytes', 'Storage', 'caching.cache_storage', 'stacked'],
        'lines': [
            ['CacheUsed', 'used', 'absolute', 1, 1000000000],
            ['CacheFree', 'free', 'absolute', 1, 1000000000],
            ['CacheLimit', 'limit', 'absolute', 1, 1000000000],
            ['PersonalCacheUsed', 'personalused', 'absolute', 1, 1000000000],
            ['PersonalCacheFree', 'personalfree', 'absolute', 1, 1000000000],
            ['PersonalCacheLimit', 'personallimit', 'absolute', 1, 1000000000]
        ]},
    'cache_content': {
        'options': [None, 'Breakdown of Cached Content', 'Gigabytes', 'Content', 'caching.cache_content', 'stacked'],
        'lines': [
            ['Mac Software', 'mac', 'absolute', 1, 1000000000],
            ['iOS Software', 'ios', 'absolute', 1, 1000000000],
            ['Apple TV Software', 'appletv', 'absolute', 1, 1000000000],
            ['Other', 'other', 'absolute', 1, 1000000000],
            ['iCloud', 'icloud', 'absolute', 1, 1000000000],
            ['Books', 'books', 'absolute', 1, 1000000000]
        ]},
    'cache_served': {
        'options': [None, 'Where the Data Came From and Where It Went', 'Gigabytes', 'Served', 'caching.cache_served', 'area'],
        'lines': [
            ['TotalBytesStoredFromOrigin', 'fromorigin', 'absolute', 1, 1000000000],
            ['TotalBytesStoredFromParents', 'fromparents', 'absolute', 1, 1000000000],
            ['TotalBytesStoredFromPeers', 'frompeers', 'absolute', 1, 1000000000],
            ['TotalBytesReturnedToChildren', 'tochildren', 'absolute', 1, 1000000000],
            ['TotalBytesReturnedToClients', 'toclients', 'absolute', 1, 1000000000],
            ['TotalBytesReturnedToPeers', 'topeers', 'absolute', 1, 1000000000]
        ]},
    'cache_status': {
        'options': [None, 'Registration Status', 'Status', 'Availability', 'caching.cache_status', 'area'],
        'lines': [
            ['RegistrationStatus', 'Regstatus', 'absolute', 1, 1]
        ]},
    'cache_port': {
        'options': [None, 'Cache running on port number', 'Running on Port', 'Cache port info',  'caching.cache_port', 'line'],
        'lines': [
            ['Port', 'Cache Port', 'absolute', 1 ,1]
        ]}
}

class Service(SimpleService):
    def __init__(self, configuration=None, name=None):
        SimpleService.__init__(self, configuration=configuration, name=name)
        self.order = ORDER
        self.definitions = CHARTS

    def get_data(self):
        out = check_output(["AssetCacheManagerUtil", "status", "-j"])
        json_data = out
        loaded_json = json.loads(json_data)
        raw = loaded_json['result']
	to_netdata = dict()
	if raw['Activated'] == 0:
	    return {'RegistrationStatus': '0'}
	elif raw['Activated'] == True:
	    for x in CACHE_STATS:
	        if x in raw:
	            to_netdata[x] = raw[x]
	    for key in CACHE_DETAILS:
	        if key in raw['CacheDetails']:
                    to_netdata[key] = raw['CacheDetails'][key]
            return to_netdata

