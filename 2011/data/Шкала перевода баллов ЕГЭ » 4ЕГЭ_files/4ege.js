var adfoxBiddersMap = {
	"alfasense": "1056746",
	"rtbhouse": "1019105",
	"getintent": "1048899",
	"mytarget": "952961",
	"betweenDigital": "957893",
	"adriver": "930088"
};
var adUnits = [
    {
        "code": "adfox_158862050352157547",
        "bids": [
			 {
                "bidder": "betweenDigital",
                "params": {
                    "placementId": "3862674"
                }
            },
			{
                "bidder": "getintent",
                "params": {
                    "placementId": "66_300x250_alfadart"
                }
            },
			{
                "bidder": "alfasense",
                "params": {
                    "placementId": "1399"
                }
            },
			{
                "bidder": "rtbhouse",
                "params": {
                    "placementId": "Mp6nDymhcpPJLmlpiwMu"
                }
            },
            {
                "bidder": "mytarget",
                "params": {
                    "placementId": "770562"
                }
            },
            {
                "bidder": "adriver",
                "params": {
                    "placementId": "57:4ege_300x250_1"
                }
            }
        ],
        "sizes": [
            [
                300,
                250
            ]
        ]
    },
    {
        "code": "adfox_158862050491519756",
        "bids": [
			 {
                "bidder": "betweenDigital",
                "params": {
                    "placementId": "3862673"
                }
            },
			{
                "bidder": "getintent",
                "params": {
                    "placementId": "66_300x250_alfadart"
                }
            },
			{
                "bidder": "alfasense",
                "params": {
                    "placementId": "1399"
                }
            },
			{
                "bidder": "rtbhouse",
                "params": {
                    "placementId": "Mp6nDymhcpPJLmlpiwMu"
                }
            },
            {
                "bidder": "mytarget",
                "params": {
                    "placementId": "771407"
                }
            },
            {
                "bidder": "adriver",
                "params": {
                    "placementId": "57:4ege_300x250_2"
                }
            }
        ],
        "sizes": [
            [
                300,
                250
            ]
        ]
    },
	{
        "code": "adfox_158862050587475244",
        "bids": [
			 {
                "bidder": "betweenDigital",
                "params": {
                    "placementId": "3862672"
                }
            },
			{
                "bidder": "getintent",
                "params": {
                    "placementId": "66_300x600_alfadart"
                }
            },
			{
                "bidder": "alfasense",
                "params": {
                    "placementId": "1399"
                }
            },
			{
                "bidder": "rtbhouse",
                "params": {
                    "placementId": "Mp6nDymhcpPJLmlpiwMu"
                }
            },
             {
                "bidder": "mytarget",
                "params": {
                    "placementId": "771409"
                }
            },
            {
                "bidder": "adriver",
                "params": {
                    "placementId": "57:4ege_300x600"
                }
            }
        ],
        "sizes": [
            [
                300,
                600
            ]
        ]
    },
    {
        "code": "adfox_15901340131374337",
        "bids": [
			 {
                "bidder": "betweenDigital",
                "params": {
                    "placementId": "3916701"
                }
            },
			{
                "bidder": "getintent",
                "params": {
                    "placementId": "66_320x100_alfadart"
                }
            },
			{
                "bidder": "alfasense",
                "params": {
                    "placementId": "1399"
                }
            },
			{
                "bidder": "rtbhouse",
                "params": {
                    "placementId": "Mp6nDymhcpPJLmlpiwMu"
                }
            },
             {
                "bidder": "mytarget",
                "params": {
                    "placementId": "778354"
                }
            },
        ],
        "sizes": [
            [
                320,
                100
            ]
        ]
    }
];
var userTimeout = 500;
window.YaHeaderBiddingSettings = {
    biddersMap: adfoxBiddersMap,
    adUnits: adUnits,
    timeout: userTimeout
};