FROM python:3.11-alpine

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Run the render_app loop by default, because it handles the infinite loop and downloading certs.
# Or better, just run leapmotor_to_abrp.py in a loop. render_app.py also works perfectly since it loops and downloads certs.
CMD ["python", "render_app.py"]
