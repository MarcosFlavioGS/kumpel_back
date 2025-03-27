# Kumpel Chat

A secure, real-time chat application built with Phoenix and Elixir, featuring robust security measures and modern architecture.

![Elixir](https://img.shields.io/badge/Elixir-1.15-blue)
![Phoenix](https://img.shields.io/badge/Phoenix-1.7-green)
![License](https://img.shields.io/badge/license-MIT-blue)

## Features

- 🔒 **Secure Authentication**
  - JWT-based authentication with refresh tokens
  - Rate limiting on login attempts
  - Password hashing with Argon2
  - Session management and security headers

- 💬 **Real-time Chat**
  - WebSocket-based communication
  - Multiple chat rooms support
  - Message rate limiting
  - Message sanitization and validation

- 🛡️ **Security Features**
  - Comprehensive audit logging
  - Input validation and sanitization
  - Rate limiting on API endpoints
  - XSS protection
  - CSRF protection
  - Secure headers configuration

- 🔍 **Monitoring & Logging**
  - Detailed audit logs for security events
  - Performance monitoring
  - User activity tracking
  - Security incident logging

## Tech Stack

- **Backend**: Elixir/Phoenix
- **Database**: PostgreSQL
- **Cache**: Cachex
- **Authentication**: JWT
- **Real-time**: Phoenix Channels
- **Security**: Argon2, Guardian

## Getting Started

### Prerequisites

- Elixir 1.15 or later
- Erlang/OTP 25 or later
- PostgreSQL 14 or later
- Node.js 18 or later (for assets)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/kumpel_back.git
   cd kumpel_back
   ```

2. Install dependencies:
   ```bash
   mix deps.get
   cd assets && npm install && cd ..
   ```

3. Set up the database:
   ```bash
   mix ecto.setup
   ```

4. Start the Phoenix server:
   ```bash
   mix phx.server
   ```

The application will be available at `http://localhost:4000`.

## API Documentation

### Authentication

```http
POST /api/auth/login
Content-Type: application/json

{
  "mail": "user@example.com",
  "password": "secure_password"
}
```

### WebSocket Connection

```javascript
const socket = new Socket("/socket", {
  params: { token: "your_jwt_token" }
});
```

## Security Features

### Authentication
- JWT-based authentication with refresh tokens
- Rate limiting on login attempts (5 attempts per 5 minutes)
- Secure password hashing with Argon2
- Session management with secure headers

### Chat Security
- Message rate limiting (30 messages per minute)
- Input validation and sanitization
- XSS protection
- Room access control
- Connection limits per room

### API Security
- Rate limiting on endpoints
- CSRF protection
- Secure headers configuration
- Input validation
- Audit logging

## Development

### Running Tests

```bash
mix test
```

### Code Style

The project follows the [Elixir Style Guide](https://github.com/christopheradams/elixir_style_guide).

### Database Migrations

```bash
mix ecto.migrate
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Phoenix Framework](https://www.phoenixframework.org/)
- [Elixir](https://elixir-lang.org/)
- [Guardian](https://github.com/ueberauth/guardian)
- [Argon2](https://github.com/riverrun/argon2_elixir)

## Support

For support, please open an issue in the GitHub repository or contact the maintainers.
