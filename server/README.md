# SmartCal Backend Server

Express server for handling Gemini AI recommendations for the SmartCal nutrition tracker.

## Setup

1. Install dependencies:
```bash
cd server
npm install
```

2. Create a `.env` file:
```bash
copy .env.example .env
```

3. Add your Gemini API key to `.env`:
```
GEMINI_API_KEY=your_actual_api_key_here
PORT=3000
```

## Running the Server

Development mode (with auto-reload):
```bash
npm run dev
```

Production mode:
```bash
npm start
```

## API Endpoints

### Health Check
- **GET** `/api/health`
- Returns server status

### Get Recommendation
- **POST** `/api/recommendation`
- Body: 
```json
{
  "summary": {
    "items": [...],
    "totals": { "calories": 0, "protein": 0, "fats": 0, "carbs": 0 }
  }
}
```
- Returns: AI-generated nutrition recommendation

## Security Notes

- Never commit the `.env` file
- Keep your Gemini API key secure
- The server uses CORS to allow frontend access
