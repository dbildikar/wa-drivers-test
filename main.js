// Working main controller that properly connects all components
class MainController {
    constructor() {
        this.database = null;
        this.testManager = null;
        this.uiManager = null;
    }

    async init() {
        try {
            console.log('Initializing application...');
            
            // Use the existing database instance
            this.database = window.questionDB;
            console.log('Database connected:', this.database);
            
            // Initialize test manager with database
            this.testManager = new TestManager();
            console.log('Test manager initialized');
            
            // Initialize UI manager
            this.uiManager = new UIManager();
            console.log('UI manager initialized');
            
            // Store globally for other functions to access
            window.database = this.database;
            window.testManager = this.testManager;
            window.uiManager = this.uiManager;
            
            console.log('Application initialized successfully');
        } catch (error) {
            console.error('Failed to initialize application:', error);
        }
    }
}

// Initialize application when DOM is loaded
document.addEventListener('DOMContentLoaded', async () => {
    console.log('DOM loaded, initializing application...');
    window.mainController = new MainController();
    await window.mainController.init();
    
    // Add event listeners
    setupEventListeners();
});

function setupEventListeners() {
    // Start test button
    const startTestBtn = document.getElementById('start-test-btn');
    if (startTestBtn) {
        startTestBtn.addEventListener('click', startTest);
    }
    
    // Navigation buttons
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');
    const submitBtn = document.getElementById('submit-btn');
    const restartBtn = document.getElementById('restart-test-btn');
    
    if (prevBtn) prevBtn.addEventListener('click', previousQuestion);
    if (nextBtn) nextBtn.addEventListener('click', nextQuestion);
    if (submitBtn) submitBtn.addEventListener('click', submitTest);
    if (restartBtn) restartBtn.addEventListener('click', restartTest);
    
    // Update question count display
    updateQuestionCountDisplay();
    
    // Set up authentication callbacks
    setupAuthCallbacks();
}

function setupAuthCallbacks() {
    if (window.authManager) {
        // Override the default login success callback
        window.authManager.onLoginSuccess = function() {
            console.log('User logged in, loading any saved progress...');
            // You can add logic here to load user's saved progress
            // For example, load previous test results, saved questions, etc.
        };
        
        // Override the default logout success callback
        window.authManager.onLogoutSuccess = function() {
            console.log('User logged out, clearing user data...');
            // You can add logic here to clear user-specific data
            // For example, clear test results, reset progress, etc.
        };
    }
}

function updateQuestionCountDisplay() {
    const questionCountElement = document.getElementById('question-count');
    if (questionCountElement && window.TEST_CONFIG) {
        questionCountElement.textContent = window.TEST_CONFIG.DEFAULT_QUESTION_COUNT;
    }
}

// Test starting function
async function startTest() {
    try {
        console.log('Start test button clicked! Starting test...');
        
        // Show test container, hide main content
        const testContainer = document.getElementById('test-container');
        const mainContent = document.querySelector('.main-content');
        
        if (testContainer && mainContent) {
            mainContent.classList.add('hidden');
            testContainer.classList.remove('hidden');
            
            // Start the test
            if (window.testManager) {
                await window.testManager.startTest();
                console.log('Test manager started test');
                
                if (window.uiManager) {
                    window.uiManager.showQuestion();
                    console.log('First question shown');
                } else {
                    console.error('UI manager not available');
                }
            } else {
                console.error('Test manager not available');
            }
            
            console.log('Test started successfully');
        } else {
            console.error('Test container or header not found');
        }
    } catch (error) {
        console.error('Failed to start test:', error);
    }
}

// Global functions for test navigation
function nextQuestion() {
    if (window.testManager && window.testManager.nextQuestion()) {
        window.uiManager.showQuestion();
    }
}

function previousQuestion() {
    if (window.testManager && window.testManager.previousQuestion()) {
        window.uiManager.showQuestion();
    }
}

function submitTest() {
    if (window.testManager) {
        const results = window.testManager.submitTest();
        if (results) {
            window.uiManager.showTestResults(results);
        }
    }
}

function restartTest() {
    if (window.testManager) {
        window.testManager.resetTest();
        
        // Hide test and results, show main content
        const testContainer = document.getElementById('test-container');
        const resultsContainer = document.getElementById('results-container');
        const mainContent = document.querySelector('.main-content');
        
        if (testContainer) testContainer.classList.add('hidden');
        if (resultsContainer) resultsContainer.classList.add('hidden');
        if (mainContent) mainContent.classList.remove('hidden');
    }
}



