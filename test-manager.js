class TestManager {
    constructor() {
        this.currentQuestions = [];
        this.currentQuestionIndex = 0;
        this.userAnswers = [];
        this.testStarted = false;
        this.testCompleted = false;
        this.score = 0;
        this.correctAnswers = 0;
        this.wrongAnswers = [];
    }

    async startTest(questionCount = null) {
        try {
            console.log('Starting test...');
            
            // Load questions if not already loaded
            await window.questionDB.loadQuestions();
            
            // Get question count from config if not specified
            const count = questionCount || 2; // Default to 2 questions
            console.log(`Starting test with ${count} questions`);
            
            // Get random questions
            this.currentQuestions = window.questionDB.getRandomQuestions(count);
            console.log(`Loaded ${this.currentQuestions.length} questions:`, this.currentQuestions);
            
            // Initialize test state
            this.currentQuestionIndex = 0;
            this.userAnswers = new Array(this.currentQuestions.length).fill(null);
            this.testStarted = true;
            this.testCompleted = false;
            this.score = 0;
            this.correctAnswers = 0;
            this.wrongAnswers = [];
            
            return this.currentQuestions;
        } catch (error) {
            console.error('Failed to start test:', error);
            throw error;
        }
    }

    getCurrentQuestion() {
        if (!this.testStarted || this.currentQuestionIndex >= this.currentQuestions.length) {
            return null;
        }
        return this.currentQuestions[this.currentQuestionIndex];
    }

    getCurrentQuestionNumber() {
        return this.currentQuestionIndex + 1;
    }

    getTotalQuestions() {
        return this.currentQuestions.length;
    }

    answerQuestion(answerIndex) {
        if (!this.testStarted || this.currentQuestionIndex >= this.currentQuestions.length) {
            return false;
        }
        
        this.userAnswers[this.currentQuestionIndex] = answerIndex;
        console.log(`Question ${this.currentQuestionIndex + 1} answered: ${answerIndex}`);
        return true;
    }

    canGoToNext() {
        return this.userAnswers[this.currentQuestionIndex] !== null;
    }

    canGoToPrevious() {
        return this.currentQuestionIndex > 0;
    }

    nextQuestion() {
        if (this.currentQuestionIndex < this.currentQuestions.length - 1) {
            this.currentQuestionIndex++;
            console.log(`Moved to question ${this.currentQuestionIndex + 1}`);
            return true;
        }
        return false;
    }

    previousQuestion() {
        if (this.currentQuestionIndex > 0) {
            this.currentQuestionIndex--;
            console.log(`Moved to question ${this.currentQuestionIndex + 1}`);
            return true;
        }
        return false;
    }

    canSubmit() {
        // Can submit if we're on the last question and it's answered
        return this.currentQuestionIndex === this.currentQuestions.length - 1 && 
               this.userAnswers[this.currentQuestionIndex] !== null;
    }

    submitTest() {
        if (!this.testStarted || this.testCompleted) {
            return null;
        }

        console.log('Submitting test...');
        console.log('User answers:', this.userAnswers);
        console.log('Current questions:', this.currentQuestions);

        // Calculate results
        this.correctAnswers = 0;
        this.wrongAnswers = [];

        this.userAnswers.forEach((userAnswer, index) => {
            const question = this.currentQuestions[index];
            console.log(`Processing question ${index + 1}:`, question);
            
            if (userAnswer === question.correct) {
                this.correctAnswers++;
                console.log(`Question ${index + 1} correct`);
            } else {
                this.wrongAnswers.push({
                    question: question.question,
                    userAnswer: question.options[userAnswer],
                    correctAnswer: question.options[question.correct],
                    explanation: question.explanation || 'No explanation available',
                    source: question.source || 'WA DOL Driver Guide',
                    questionIndex: index + 1
                });
                console.log(`Question ${index + 1} wrong`);
            }
        });

        this.score = Math.round((this.correctAnswers / this.currentQuestions.length) * 100);
        this.testCompleted = true;

        console.log(`Test completed. Score: ${this.score}% (${this.correctAnswers}/${this.currentQuestions.length})`);
        console.log('Wrong answers:', this.wrongAnswers);

        return {
            score: this.score,
            correctAnswers: this.correctAnswers,
            totalQuestions: this.currentQuestions.length,
            wrongAnswers: this.wrongAnswers,
            passed: this.score >= window.TEST_CONFIG.PASSING_SCORE
        };
    }

    resetTest() {
        this.currentQuestions = [];
        this.currentQuestionIndex = 0;
        this.userAnswers = [];
        this.testStarted = false;
        this.testCompleted = false;
        this.score = 0;
        this.correctAnswers = 0;
        this.wrongAnswers = [];
    }
}

// Global test manager instance
window.testManager = new TestManager();
