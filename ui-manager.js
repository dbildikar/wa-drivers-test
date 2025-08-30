class UIManager {
    constructor() {
        this.currentQuestionIndex = 0;
    }

    showQuestion() {
        const question = window.testManager.getCurrentQuestion();
        if (!question) return;

        // Update question text
        const questionText = document.getElementById('question-text');
        if (questionText) {
            questionText.textContent = question.question;
        }

        // Update progress
        const currentQuestion = document.getElementById('current-question');
        const totalQuestions = document.getElementById('total-questions');
        if (currentQuestion) currentQuestion.textContent = window.testManager.getCurrentQuestionNumber();
        if (totalQuestions) totalQuestions.textContent = window.testManager.getTotalQuestions();

        // Clear previous answers
        const answersContainer = document.getElementById('answers-container');
        if (answersContainer) {
            answersContainer.innerHTML = '';
            
            question.options.forEach((option, index) => {
                const answerOption = document.createElement('div');
                answerOption.className = 'answer-option';
                answerOption.textContent = option;
                
                // Check if this option was previously selected
                if (window.testManager.userAnswers[window.testManager.currentQuestionIndex] === index) {
                    answerOption.classList.add('selected');
                }
                
                answerOption.addEventListener('click', () => this.selectAnswer(index));
                answersContainer.appendChild(answerOption);
            });
        }

        this.updateNavigationButtons();
    }

    selectAnswer(answerIndex) {
        // Remove previous selection
        const allOptions = document.querySelectorAll('.answer-option');
        allOptions.forEach(option => option.classList.remove('selected'));
        
        // Select new answer
        const selectedOption = document.querySelectorAll('.answer-option')[answerIndex];
        if (selectedOption) {
            selectedOption.classList.add('selected');
        }

        // Record answer in test manager
        window.testManager.answerQuestion(answerIndex);
        
        // Update navigation buttons
        this.updateNavigationButtons();
    }

    updateNavigationButtons() {
        const prevBtn = document.getElementById('prev-btn');
        const nextBtn = document.getElementById('next-btn');
        const submitBtn = document.getElementById('submit-btn');

        if (prevBtn) {
            prevBtn.disabled = !window.testManager.canGoToPrevious();
        }

        if (nextBtn) {
            if (window.testManager.canSubmit()) {
                nextBtn.classList.add('hidden');
            } else {
                nextBtn.classList.remove('hidden');
            }
            nextBtn.disabled = !window.testManager.canGoToNext();
        }

        if (submitBtn) {
            if (window.testManager.canSubmit()) {
                submitBtn.classList.remove('hidden');
            } else {
                submitBtn.classList.add('hidden');
            }
            submitBtn.disabled = !window.testManager.canSubmit();
        }
    }

    showTestResults(results) {
        const testContainer = document.getElementById('test-container');
        const resultsContainer = document.getElementById('results-container');
        const resultsContent = document.getElementById('results-content');
        
        if (testContainer) testContainer.classList.add('hidden');
        if (resultsContainer) resultsContainer.classList.remove('hidden');
        
        if (resultsContent) {
            let resultsHTML = `
                <div class="score-display">
                    <h2>Test Complete!</h2>
                    <div class="score">${results.score}%</div>
                    <div class="pass-fail ${results.passed ? 'passed' : 'failed'}">
                        ${results.passed ? 'PASSED!' : 'FAILED - Need 80% to pass'}
                    </div>
                    <p>${results.correctAnswers} out of ${results.totalQuestions} correct</p>
                </div>
            `;

            if (results.wrongAnswers && results.wrongAnswers.length > 0) {
                resultsHTML += `
                    <div class="wrong-answers-section">
                        <h3>Questions You Missed</h3>
                `;

                results.wrongAnswers.forEach((wrongAnswer, index) => {
                    resultsHTML += `
                        <div class="wrong-answer-item">
                            <h4>Question ${wrongAnswer.questionIndex}: ${wrongAnswer.question}</h4>
                            <div class="answer-comparison">
                                <div class="answer-box user-answer">
                                    <strong>Your Answer:</strong><br>
                                    ${wrongAnswer.userAnswer} ❌
                                </div>
                                <div class="answer-box correct-answer">
                                    <strong>Correct Answer:</strong><br>
                                    ${wrongAnswer.correctAnswer} ✅
                                </div>
                            </div>
                            <div class="explanation-box">
                                <h5>Why this is correct:</h5>
                                <p>${wrongAnswer.explanation}</p>
                            </div>
                            <div class="source-reference">
                                <strong>Source:</strong> ${wrongAnswer.source}
                            </div>
                        </div>
                    `;
                });

                resultsHTML += '</div>';
            } else {
                resultsHTML += `
                    <div class="score-display" style="background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%); border-color: #10b981;">
                        <h2 style="color: #065f46;">🎉 Perfect Score! 🎉</h2>
                        <p style="color: #065f46; font-size: 1.2rem;">Excellent work!</p>
                    </div>
                `;
            }

            resultsContent.innerHTML = resultsHTML;
        }
    }

    restartTest() {
        window.testManager.resetTest();
        
        // Hide results and test containers
        const testContainer = document.getElementById('test-container');
        const resultsContainer = document.getElementById('results-container');
        
        if (testContainer) testContainer.classList.add('hidden');
        if (resultsContainer) resultsContainer.classList.add('hidden');
        
        // Show main content
        const mainContent = document.querySelector('.main-content');
        if (mainContent) mainContent.classList.remove('hidden');
    }
}
