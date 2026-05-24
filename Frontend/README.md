# CLMS Frontend - Computer Lab Management System

## Tech Stack

- **UI Library**: React 18
- **Build Tool**: Vite
- **Routing**: React Router 6
- **State Management**: Zustand
- **HTTP Client**: Axios
- **CSS Framework**: TailwindCSS
- **Icons**: Lucide React
- **Date Utils**: date-fns
- **Notifications**: react-hot-toast

## Folder Structure

```
Frontend/
├── src/
│   ├── components/
│   │   ├── layout/       # AppLayout, Sidebar, Topbar
│   │   └── ui/           # Badge, Loader, Modal, Pagination
│   ├── pages/
│   │   ├── auth/         # Login, Register, VerifyEmail, ForgotPassword, ResetPassword
│   │   ├── labrooms/     # LabRoomsPage, LabRoomDetailPage
│   │   ├── workstations/ # WorkstationsPage, WorkstationDetailPage
│   │   ├── reservations/ # MyReservationsPage, ReservationQueuePage
│   │   ├── incidents/    # IncidentsPage, IncidentDetailPage
│   │   ├── admin/        # UsersPage, ReportsPage
│   │   ├── DashboardPage.jsx
│   │   └── ProfilePage.jsx
│   ├── services/         # API service layer
│   ├── store/            # Zustand state management
│   ├── lib/              # api.js, auth.jsx, utils.js
│   ├── App.jsx
│   └── main.jsx
├── index.html
├── vite.config.js
├── tailwind.config.js
├── postcss.config.js
└── package.json
```

## Setup

### 1. Prerequisites

- Node.js >= 16
- Backend server running on port 5000

### 2. Install & Run

```bash
cd Frontend
npm install
npm run dev
```

Frontend runs on: http://localhost:5173

## Features

- **Authentication**: Login, Register, Email verification, Password reset
- **Role-based Access**: Customer, Lab Staff, System Admin
- **Lab Room Management**: View, create, update, delete rooms
- **Workstation Management**: View, create, update, delete workstations
- **Reservations**: Book lab rooms or workstations, approve/reject
- **Incident Reporting**: Report hardware/network/os/software issues
- **Admin Dashboard**: User management, reports, statistics

## Role Permissions

| Feature | Customer | Lab Staff | System Admin |
|---------|----------|-----------|-------------|
| View rooms/workstations | Yes | Yes | Yes |
| Book reservations | Yes | Yes | Yes |
| Approve reservations | No | Yes | Yes |
| Handle incidents | No | Yes | Yes |
| Manage users | No | No | Yes |
| Manage rooms/workstations | No | No | Yes |
| View reports | No | No | Yes |
