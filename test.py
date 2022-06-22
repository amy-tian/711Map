import pandas as pd
import requests
import json

df = pd.read_csv("test_10address.csv")
pd.set_option('display.max_rows', None)

for i, row in df.iterrows():
    apiAddress = str(df.at[i,'address'])+','+str(df.at[i,'county'])+','+str(df.at[i,'town'])+','+str(df.at[i,'name'])

    parameters = {
        "key": "K32gGRbg4EsWAaagnvPL3ERsmOPJ2pgJ",
        "location": apiAddress
    }

    response = requests.get("http://www.mapquestapi.com/geocoding/v1/address", params=parameters)
    print(response)
    data = response.text
    # print(i )
    # print(row )
    dataJ = json.loads(data)['results']
    lat = (dataJ[0]['locations'][0]['latLng']['lat'])
    lng = (dataJ[0]['locations'][0]['latLng']['lng'])

    df.at[i,'lat'] = lat
    df.at[i,'lng'] = lng

df.to_csv('complete_data_geo2.csv')
