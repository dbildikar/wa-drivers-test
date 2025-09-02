# Washington State Drivers Test

A professional, interactive practice test website for the Washington State driver's license exam. Features a modern UI with detailed explanations for incorrect answers.

## ✨ Features

- **Professional Design**: Modern, responsive interface with gradient backgrounds and clean typography
- **Practice Tests**: Configurable question count (default: 2 questions for quick testing)
- **Real Questions**: Uses actual Washington State driver's license exam questions
- **Detailed Explanations**: Shows why answers are correct/incorrect with source references
- **Mobile Responsive**: Works perfectly on all devices

## 🚀 Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/dbildikar/wa-drivers-test.git
   cd wa-drivers-test
   ```

2. **Start the development server**:
   ```bash
   python3 -m http.server 8001
   ```

3. **Open your browser** and navigate to `http://localhost:8001`

## 🔐 Future: Google OAuth Integration

When you're ready to deploy to a hosted solution with HTTPS, you can add Google OAuth authentication:

1. **Deploy to a hosting service** (Netlify, Vercel, AWS, etc.)
2. **Set up Google Cloud Console** with OAuth 2.0 credentials
3. **Add the authentication code** back to the project
4. **Enable user accounts** and progress tracking

For now, the site works perfectly as a standalone practice test application!

## 📁 Project Structure

```
wa-drivers-test/
├── index.html              # Main HTML file with clean, professional interface
├── new-styles.css          # Professional styling with responsive design
├── main.js                 # Main application controller
├── ui-manager.js           # UI state management
├── test-manager.js         # Test logic and scoring
├── database.js             # Question data management
├── wa_drivers_ed_question_bank_final.jsonl  # Question bank
└── README.md               # This file
```

## 🎯 How It Works

1. **User visits the site** and sees a professional landing page
2. **User can take practice tests** with real Washington State questions
3. **Results are displayed** with detailed explanations and sources
4. **Clean, focused experience** without authentication complexity

## 🔧 Customization

### Changing Question Count

Update the default question count in `database.js`:

```javascript
window.TEST_CONFIG = {
    DEFAULT_QUESTION_COUNT: 5,  // Change from 2 to any number
    PASSING_SCORE: 80,
    AUTO_ADVANCE_DELAY: 2000
};
```

### Modifying Styling

The CSS uses CSS custom properties and modern features. Main color scheme is defined in `new-styles.css`:

```css
:root {
    --primary-color: #3b82f6;
    --secondary-color: #1d4ed8;
    --accent-color: #10b981;
}
```

### Adding New Features

The modular architecture makes it easy to add new features:

- **New UI components**: Add to `ui-manager.js`
- **Authentication features**: Extend `auth-manager.js`
- **Test logic**: Modify `test-manager.js`
- **Data handling**: Update `database.js`

## 🌐 Deployment

### Local Development
```bash
python3 -m http.server 8001
```

### Production Deployment
1. Upload files to your web server
2. Update Google OAuth origins to include your domain
3. Ensure HTTPS is enabled (required for OAuth)
4. Update the client ID in production

## 📱 Browser Support

- ✅ Chrome 80+
- ✅ Firefox 75+
- ✅ Safari 13+
- ✅ Edge 80+

## 🔒 Security Features

- **OAuth 2.0**: Secure authentication with Google
- **JWT Token Validation**: Proper token parsing and validation
- **Local Storage**: Secure user session management
- **No Sensitive Data**: Questions and answers are public domain

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available under the MIT License.

## 🆘 Support

If you encounter any issues:

1. Check the browser console for error messages
2. Verify your Google OAuth configuration
3. Ensure all files are properly loaded
4. Check that your domain is authorized in Google Cloud Console

## 🎉 Acknowledgments

- Washington State Department of Licensing for the question bank
- Google for OAuth 2.0 authentication services
- Modern web standards for the responsive design
