FROM python:3.10-slim

# app directory
WORKDIR /app

# demo user
ARG USER_ID=1000
ARG GROUP_ID=1000

RUN groupadd -g ${GROUP_ID} demo \
 && useradd -m -u ${USER_ID} -g ${GROUP_ID} demo

# copy only requirements first (mejor cache)
COPY requirements.txt .

# install dependencies
RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# copy rest of the app
COPY --chown=demo:demo . /app/

USER demo

# entrypoint
CMD ["uvicorn", "app.main:app", "--proxy-headers", "--host", "0.0.0.0", "--port", "8080"]
