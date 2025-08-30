class AuthManager {
    constructor() {
        this.user = null;
        this.isAuthenticated = false;
        this.init();
    }

    init() {
        // Check if user is already logged in (from localStorage)
        this.checkExistingSession();
        
        // Set up logout button event listener
        this.setupLogoutButton();
    }

    checkExistingSession() {
        const savedUser = localStorage.getItem('wa-drivers-test-user');
        if (savedUser) {
            try {
                this.user = JSON.parse(savedUser);
                this.isAuthenticated = true;
                this.showUserProfile();
            } catch (e) {
                console.error('Failed to parse saved user data:', e);
                this.logout();
            }
        }
    }

    handleCredentialResponse(response) {
        try {
            // Decode the JWT token to get user info
            const payload = this.decodeJwtResponse(response.credential);
            
            this.user = {
                id: payload.sub,
                name: payload.name,
                email: payload.email,
                picture: payload.picture,
                loginTime: new Date().toISOString()
            };
            
            this.isAuthenticated = true;
            
            // Save to localStorage
            localStorage.setItem('wa-drivers-test-user', JSON.stringify(this.user));
            
            // Update UI
            this.showUserProfile();
            
            console.log('User logged in successfully:', this.user.name);
            
            // Trigger any post-login actions
            this.onLoginSuccess();
            
        } catch (error) {
            console.error('Failed to handle credential response:', error);
            alert('Login failed. Please try again.');
        }
    }

    decodeJwtResponse(token) {
        try {
            const base64Url = token.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
                return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
            }).join(''));
            return JSON.parse(jsonPayload);
        } catch (e) {
            throw new Error('Invalid token format');
        }
    }

    showUserProfile() {
        const loginSection = document.getElementById('login-section');
        const userProfile = document.getElementById('user-profile');
        const userAvatar = document.getElementById('user-avatar');
        const userName = document.getElementById('user-name');
        
        if (loginSection && userProfile && userAvatar && userName) {
            loginSection.classList.add('hidden');
            userProfile.classList.remove('hidden');
            
            userAvatar.src = this.user.picture;
            userName.textContent = this.user.name;
        }
    }

    showLoginSection() {
        const loginSection = document.getElementById('login-section');
        const userProfile = document.getElementById('user-profile');
        
        if (loginSection && userProfile) {
            loginSection.classList.remove('hidden');
            userProfile.classList.add('hidden');
        }
    }

    logout() {
        this.user = null;
        this.isAuthenticated = false;
        
        // Clear localStorage
        localStorage.removeItem('wa-drivers-test-user');
        
        // Update UI
        this.showLoginSection();
        
        console.log('User logged out successfully');
        
        // Trigger any post-logout actions
        this.onLogoutSuccess();
    }

    setupLogoutButton() {
        const logoutBtn = document.getElementById('logout-btn');
        if (logoutBtn) {
            logoutBtn.addEventListener('click', () => this.logout());
        }
    }

    onLoginSuccess() {
        // This can be overridden by other components
        // For example, to load user's saved progress
        console.log('Login success callback triggered');
    }

    onLogoutSuccess() {
        // This can be overridden by other components
        // For example, to clear user data
        console.log('Logout success callback triggered');
    }

    // Getter methods for other components
    getCurrentUser() {
        return this.user;
    }

    isUserLoggedIn() {
        return this.isAuthenticated;
    }

    getUserId() {
        return this.user ? this.user.id : null;
    }

    getUserEmail() {
        return this.user ? this.user.email : null;
    }
}

// Global authentication manager instance
window.authManager = new AuthManager();

// Global callback function for Google OAuth
function handleCredentialResponse(response) {
    if (window.authManager) {
        window.authManager.handleCredentialResponse(response);
    }
}
