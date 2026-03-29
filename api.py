from fastapi import FastAPI, HTTPException
from scrapling.fetchers import Fetcher
from markdownify import markdownify

app = FastAPI()
fetcher = Fetcher(impersonate="chrome")


@app.get("/scrape")
def scrape(url: str, selector: str = None):
    try:
        response = fetcher.get(url)
        if selector:
            matches = response.css(selector)
            content = [el.text for el in matches]
        else:
            content = markdownify(response.body.decode("utf-8"))
        return {"url": url, "content": content}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
