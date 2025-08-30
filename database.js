class QuestionDatabase {
    constructor() {
        this.questions = [];
        this.isLoaded = false;
        this.loadingPromise = null;
    }

    async loadQuestions() {
        if (this.isLoaded) {
            return this.questions;
        }

        if (this.loadingPromise) {
            return this.loadingPromise;
        }

        this.loadingPromise = this._fetchQuestions();
        return this.loadingPromise;
    }

    async _fetchQuestions() {
        try {
            console.log('Fetching questions from JSONL file...');
            const response = await fetch('wa_drivers_ed_question_bank_520.jsonl');
            
            if (!response.ok) {
                throw new Error(`Failed to load questions: ${response.status}`);
            }

            const text = await response.text();
            console.log('Raw JSONL text length:', text.length);
            
            const lines = text.trim().split('\n');
            console.log('Number of lines:', lines.length);
            
            this.questions = lines
                .filter(line => line.trim())
                .map((line, index) => {
                    try {
                        const question = JSON.parse(line);
                        // Normalize the question structure
                        return {
                            id: question.id,
                            question: question.question_text,
                            options: question.answer_options,
                            correct: question.correct_index,
                            explanation: question.explanation,
                            source: question.source,
                            category: question.category,
                            difficulty: question.difficulty
                        };
                    } catch (e) {
                        console.warn(`Failed to parse line ${index + 1}:`, e);
                        return null;
                    }
                })
                .filter(q => q !== null);

            this.isLoaded = true;
            console.log(`Successfully loaded ${this.questions.length} questions`);
            console.log('Sample question:', this.questions[0]);
            return this.questions;
        } catch (error) {
            console.error('Error loading questions:', error);
            throw error;
        }
    }

    getRandomQuestions(count) {
        if (!this.isLoaded) {
            throw new Error('Questions not loaded yet');
        }

        if (count >= this.questions.length) {
            return this._shuffleArray([...this.questions]);
        }

        return this._shuffleArray([...this.questions]).slice(0, count);
    }

    _shuffleArray(array) {
        const shuffled = [...array];
        for (let i = shuffled.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
        }
        return shuffled;
    }
}

// Global configuration
window.TEST_CONFIG = {
    DEFAULT_QUESTION_COUNT: 2,  // Set to 2 for quick testing
    PASSING_SCORE: 80,
    AUTO_ADVANCE_DELAY: 2000
};

// Global database instance
window.questionDB = new QuestionDatabase();
