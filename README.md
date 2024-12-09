# Kumpel Chat Backend

## Overview
Kumpel Chat is a real-time chat room application backend built with Phoenix and Elixir, supporting multiple chat rooms with authentication and authorization.

## Features
- Lobby chat room (open access)
- Private chat rooms with access codes
- Real-time message broadcasting
- Room creation and management
- Authentication for room access

## Prerequisites
- Elixir: >= 1.12
- Erlang/OTP: >= 24
- Phoenix Framework: ~> 1.7
- PostgreSQL: Database for managing chat rooms.

## Installation

1. Clone the repository
```bash
git clone <repository-url>
cd kumpel_back
```

2. Install dependencies
```bash
mix deps.get
```

3. Setup database
```bash
mix ecto.create
mix ecto.migrate
```

4. Start the server
```bash
mix phx.server
```

## Key Modules

### ChatRoomChannel
- Handles WebSocket connections for chat rooms
- Supports joining lobby and private rooms
- Manages message broadcasting

### RoomsController
- REST API for room management
- Endpoints for creating, retrieving, updating, and deleting rooms

### Authorization
- Validates room access codes
- Manages room entry permissions

## Room Creation
Rooms require:
- Name (min 2 characters)
- Access Code (min 6 characters)
- Administrator

## WebSocket Events
- `join`: Enter a chat room
- `ping`: Get room information
- `shout`: Broadcast messages to all room participants
- `new_message`: Send a new chat message

## Configuration
Update `config/config.exs` with your specific environment settings.

## Testing
Run tests with:
```bash
mix test
```

## Contributing
1. Fork the repository
2. Create your feature branch
3. Commit changes
4. Push to the branch
5. Create a Pull Request

## License
[Add your license here]
