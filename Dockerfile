FROM python3.12
WORKDIR app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY src/ ./src
EXPOSE 5000

RUN useradd app
USER app

CMD ["unicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8080"]