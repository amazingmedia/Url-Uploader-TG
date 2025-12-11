FROM python:3.9-slim

# OS Tools များ
RUN apt-get update && apt-get install -y git ffmpeg build-essential

# Source Code ဆွဲယူခြင်း
RUN git clone https://github.com/kalanakt/Url-Uploader-TG.git /app

# ဖိုင်လမ်းကြောင်း
WORKDIR /app

# Config ဖိုင် ဖန်တီးခြင်း
RUN echo 'import os' > config.py && \
    echo 'class Config(object):' >> config.py && \
    echo '    APP_ID = int(os.environ.get("API_ID", 0))' >> config.py && \
    echo '    API_HASH = os.environ.get("API_HASH", "")' >> config.py && \
    echo '    TG_BOT_TOKEN = os.environ.get("BOT_TOKEN", "")' >> config.py && \
    echo '    AUTH_USERS = set(int(x) for x in os.environ.get("AUTH_USERS", "").split())' >> config.py && \
    echo '    DOWNLOAD_LOCATION = "./DOWNLOADS"' >> config.py

# Requirements ပြင်ဆင်ခြင်း
RUN sed -i '/aiofiles/d' requirements.txt
RUN pip install aiofiles
RUN pip install --no-cache-dir -r requirements.txt

# Bot run ခြင်း
CMD ["python3", "bot.py"]
