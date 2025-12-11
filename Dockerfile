FROM python:3.9-slim

# ၁. OS Tools များ (ca-certificates ကို အဓိက ထပ်ဖြည့်ထားသည်)
RUN apt-get update && apt-get install -y git ffmpeg build-essential ca-certificates

# ၂. Source Code ဆွဲယူခြင်း
RUN git clone https://github.com/kalanakt/Url-Uploader-TG.git /app

# ၃. ဖိုင်လမ်းကြောင်း
WORKDIR /app

# ၄. Config ဖိုင် ဖန်တီးခြင်း
RUN echo 'import os' > config.py && \
    echo 'class Config(object):' >> config.py && \
    echo '    APP_ID = int(os.environ.get("API_ID", 0))' >> config.py && \
    echo '    API_HASH = os.environ.get("API_HASH", "")' >> config.py && \
    echo '    TG_BOT_TOKEN = os.environ.get("BOT_TOKEN", "")' >> config.py && \
    echo '    AUTH_USERS = set(int(x) for x in os.environ.get("AUTH_USERS", "").split())' >> config.py && \
    echo '    DOWNLOAD_LOCATION = "./DOWNLOADS"' >> config.py && \
    echo '    DB_URI = os.environ.get("DATABASE_URL", "")' >> config.py && \
    echo '    SESSION_NAME = os.environ.get("SESSION_NAME", "Bot")' >> config.py

# ၅. Requirements ပြင်ဆင်ခြင်း (certifi ကိုပါ ထပ်ထည့်ပေးသည်)
RUN sed -i '/aiofiles/d' requirements.txt
RUN pip install aiofiles
RUN pip install certifi
RUN pip install --no-cache-dir -r requirements.txt

# ၆. Bot run ခြင်း
CMD ["python3", "bot.py"]
