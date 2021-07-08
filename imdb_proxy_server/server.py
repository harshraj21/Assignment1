from flask import Flask, request, jsonify
import requests
import json
import re

app = Flask(__name__)
queryparam = 'movie'

headerz = {
    'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36',
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8,application/json",
    "Accept-Language": "en-US,en;q=0.5",
    'Referer': 'https://www.coursera.org/learn/data-structures-design-patterns/profiles/eb212f079da79ab28e01ff739fc87b51',
}

unknownimage = 'https://lh3.googleusercontent.com/proxy/obbEzNd9UeOFFrNO-POq7bzxUa_uj2gcANxgloZ7BJWYUsQJZp64zCjjg97o5iz2ukAH21rHKc-bVP_2vNq7'


def urlbuilder(q):
    return f'https://v2.sg.media-imdb.com/suggestion/{q[0]}/{q}.json'


def urlbuilder2(id):
    return f'https://www.imdb.com/title/{id}/?ref_=nv_sr_srsg_0'


def scrape(uri):
    try:
        resp = requests.get(url=uri, headers=headerz)
        if(resp.status_code == 200):
            ufcontent = resp.content
            raw = re.findall(
                '<a class="ipc-metadata-list-item__list-content-item ipc-metadata-list-item__list-content-item--link" rel="" href="/search/title/\?genres=.+?>.+?</a>', str(ufcontent))
            re1 = re.sub(
                '<a|>|class=".*?"|rel=".*?"|href=".*?"|</a| ', '', str(raw))
            re2 = re.split('[^a-zA-Z0-9_\-]+', str(re1))
            re3 = re.findall(
                '<span class="AggregateRatingButton.*?>.*?</span>', str(ufcontent))
            re4 = re.sub(
                '<span|</span>|class=".*?"|>|[|]|\,|\',| ', '', str(re3))
            re5 = re.split('([0-9]{1,2}\.[0-9]{1,2})', str(re4))
            arr = []
            for e in re2:
                if(e != ''):
                    arr.append(e)
            if(len(arr) <= 0):
                arr.append('unknown')
            data = {
                'imdb': re5[1],
                'genre': arr,
            }
            del ufcontent
            del raw
            del re1
            del re2
            del re3
            del re4
            del re5
            return data
        else:
            return ('Error occured #3')
    except:
        return 'Error occured #4'


def fetch_data(q):
    q2 = q.replace(' ', '_')
    resp = requests.get(url=urlbuilder(q2), headers=headerz)
    if(resp.status_code == 200):
        ufcontent = resp.content
        arr = []
        try:
            fcontent = json.loads(ufcontent.decode('utf-8'))
            elements = fcontent['d']
            for element in elements:
                try:
                    moviedata = scrape(urlbuilder2(element['id']))
                    if(moviedata == 'Error occured #3' or moviedata == None or moviedata == 'Error occured #4'):
                        continue
                    try:
                        data = {
                            'name': element['l'],
                            'imgurl': element['i']['imageUrl'],
                            'moviedata': moviedata,
                        }
                    except:
                        data = {
                            'name': element['l'],
                            'imgurl': unknownimage,
                            'moviedata': moviedata,
                        }
                    arr.append(data)
                except:
                    continue
            return arr
        except Exception as e:
            return ('Error occured #2')
    else:
        return ('Error occured #1')


@app.route("/")
def home():
    return('Server is up and running!!')


@app.route("/getinfo", methods=['POST'])
def getinfo():
    if request.method == 'POST':
        req = request.json
        query = req[queryparam]
        if query == None:
            returndata = {'error': 'no query parameter passed'}
            return jsonify(returndata, 400)
        if query == "":
            returndata = {'error': 'query parameter cant be empty'}
            return jsonify(returndata, 400)

        returndata = fetch_data(query)
        return(json.dumps(returndata))
    else:
        returndata = {'error': 'invalid request'}
        return(jsonify(returndata), 405)


 if __name__ == "__main__":
     app.run()
