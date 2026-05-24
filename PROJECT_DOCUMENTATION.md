# CLMS - Computer Lab Management System
Hệ thống quản lý phòng máy tính (Computer Lab Management System) là một ứng dụng web được xây dựng nhằm hỗ trợ quản lý, đặt chỗ và theo dõi các phòng lab cùng máy trạm trong môi trường giáo dục.

---

## Mục lục

1. [Tổng quan](#tổng-quan)
2. [Kiến trúc hệ thống](#kiến-trúc-hệ-thống)
3. [Backend](#backend)
4. [Database](#database)
5. [Frontend](#frontend)
6. [Tính năng chính](#tính-năng-chính)
7. [Vai trò người dùng](#vai-trò-người-dùng)
8. [API Endpoints](#api-endpoints)
9. [Công nghệ sử dụng](#công-nghệ-sử-dụng)
10. [Cài đặt và chạy](#cài-đặt-và-chạy)

---

## Tổng quan

CLMS là hệ thống giúp:

- **Quản lý phòng lab**: Tạo, cập nhật, xóa và theo dõi các phòng máy tính
- **Quản lý máy trạm**: Theo dõi cấu hình, trạng thái từng máy trong phòng lab
- **Đặt chỗ**: Cho phép người dùng đặt phòng lab hoặc máy trạm theo khung giờ
- **Xử lý sự cố**: Báo cáo và theo dõi các sự cố về phần cứng, phần mềm, mạng
- **Báo cáo thống kê**: Xuất báo cáo về tình trạng sử dụng hệ thống

---

## Kiến trúc hệ thống

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│                 │         │                 │         │                 │
│    Frontend     │────────▶│     Backend     │────────▶│    Database     │
│   (React.js)    │  REST   │   (Node.js)     │  Prisma │  (PostgreSQL)   │
│                 │   API   │                 │  ORM    │                 │
│   Port: 3000    │         │   Port: 5000    │         │   Port: 5432    │
│                 │         │                 │         │                 │
└─────────────────┘         └─────────────────┘         └─────────────────┘
```

---

## Backend

### Cấu trúc thư mục

```
Backend/
├── src/
│   ├── config/           # Cấu hình ứng dụng
│   │   ├── bootstrap.js  # Khởi tạo database
│   │   └── prisma.js    # Prisma client
│   ├── controllers/      # Xử lý logic chính
│   │   ├── authController.js
│   │   ├── userController.js
│   │   ├── labRoomController.js
│   │   ├── workstationController.js
│   │   ├── reservationController.js
│   │   ├── incidentController.js
│   │   └── reportController.js
│   ├── routes/          # Định nghĩa routes
│   │   ├── authRoutes.js
│   │   ├── userRoutes.js
│   │   ├── labRoomRoutes.js
│   │   ├── workstationRoutes.js
│   │   ├── reservationRoutes.js
│   │   ├── incidentRoutes.js
│   │   └── reportRoutes.js
│   ├── services/        # Logic nghiệp vụ
│   │   ├── authService.js
│   │   ├── userService.js
│   │   ├── labRoomService.js
│   │   ├── workstationService.js
│   │   ├── reservationService.js
│   │   ├── incidentService.js
│   │   ├── reportService.js
│   │   └── emailService.js
│   ├── middlewares/     # Middleware xử lý
│   │   ├── auth.js      # Xác thực JWT
│   │   ├── errorHandler.js
│   │   ├── rateLimit.js
│   │   └── validate.js
│   ├── validators/      # Validation rules
│   │   ├── authValidators.js
│   │   ├── labRoomValidators.js
│   │   ├── workstationValidators.js
│   │   ├── reservationValidators.js
│   │   └── incidentValidators.js
│   ├── utils/           # Tiện ích
│   │   ├── ApiError.js
│   │   ├── asyncHandler.js
│   │   ├── datetime.js
│   │   ├── response.js
│   │   └── tokens.js
│   └── index.js         # Entry point
├── prisma/
│   └── schema.prisma    # Prisma schema
├── sql/
│   ├── schema.sql       # SQL schema gốc
│   └── seed.sql        # Dữ liệu mẫu
├── openapi.yaml         # API documentation
├── package.json
└── .env.example
```

### Các file chính

#### `src/index.js` - Entry Point
- Khởi tạo Express app
- Cấu hình CORS, cookie-parser, JSON parsing
- Mount các routes API
- Tích hợp Swagger UI cho tài liệu API
- Khởi tạo database và lắng nghe port 5000

#### `src/config/bootstrap.js` - Khởi tạo Database
- Đọc file `schema.sql` và `seed.sql`
- Tự động chạy migration khi khởi động
- Kiểm tra dữ liệu đã tồn tại trước khi seed

#### `src/middlewares/auth.js` - Xác thực
- Kiểm tra JWT token từ Authorization header
- Middleware `auth()`: Xác thực token, gắn user vào request
- Middleware `requireRole(...roles)`: Kiểm tra quyền truy cập

---

## Database

### Hệ quản trị
- **Mysql** - Hệ quản trị cơ sở dữ liệu quan hệ

### Cấu trúc bảng

#### 1. `users` - Người dùng
| Trường | Kiểu | Mô tả |
|--------|------|-------|
| id | INT (PK) | ID người dùng |
| username | VARCHAR(50) | Tên đăng nhập (unique) |
| email | VARCHAR(150) | Email (unique) |
| password | VARCHAR(255) | Mật khẩu (bcrypt hash) |
| full_name | VARCHAR(100) | Họ tên đầy đủ |
| phone | VARCHAR(20) | Số điện thoại |
| role | VARCHAR(20) | Vai trò (customer/lab_staff/system_admin) |
| status | VARCHAR(20) | Trạng thái (active/blocked/pending) |
| is_verified | BOOLEAN | Đã xác thực email |
| verification_token | VARCHAR(128) | Token xác thực email |
| failed_login_attempts | INT | Số lần đăng nhập thất bại |
| lock_until | TIMESTAMP | Thời gian khóa tài khoản |
| created_at | TIMESTAMP | Ngày tạo |
| updated_at | TIMESTAMP | Ngày cập nhật |

#### 2. `lab_rooms` - Phòng Lab
| Trường | Kiểu | Mô tả |
|--------|------|-------|
| id | INT (PK) | ID phòng |
| room_code | VARCHAR(50) | Mã phòng (unique) |
| name | VARCHAR(150) | Tên phòng |
| location | VARCHAR(255) | Vị trí |
| capacity | INT | Sức chứa (số máy) |
| description | TEXT | Mô tả chi tiết |
| status | VARCHAR(20) | Trạng thái (active/maintenance/decommissioned) |
| created_at | TIMESTAMP | Ngày tạo |
| updated_at | TIMESTAMP | Ngày cập nhật |

#### 3. `workstations` - Máy trạm
| Trường | Kiểu | Mô tả |
|--------|------|-------|
| id | INT (PK) | ID máy trạm |
| lab_room_id | INT (FK) | Phòng lab chứa máy |
| station_code | VARCHAR(50) | Mã máy |
| ip_address | VARCHAR(45) | Địa chỉ IP |
| mac_address | VARCHAR(17) | Địa chỉ MAC |
| cpu | VARCHAR(100) | CPU |
| ram_gb | INT | RAM (GB) |
| gpu | VARCHAR(100) | GPU |
| os | VARCHAR(100) | Hệ điều hành |
| state | VARCHAR(20) | Trạng thái (available/maintenance/reserved) |
| created_at | TIMESTAMP | Ngày tạo |
| updated_at | TIMESTAMP | Ngày cập nhật |

#### 4. `reservations` - Đặt chỗ
| Trường | Kiểu | Mô tả |
|--------|------|-------|
| id | INT (PK) | ID đặt chỗ |
| user_id | INT (FK) | Người đặt |
| resource_type | VARCHAR(20) | Loại (lab_room/workstation) |
| lab_room_id | INT (FK) | Phòng lab (nếu type=lab_room) |
| workstation_id | INT (FK) | Máy trạm (nếu type=workstation) |
| start_time | TIMESTAMP | Thời gian bắt đầu |
| end_time | TIMESTAMP | Thời gian kết thúc |
| purpose | VARCHAR(500) | Mục đích sử dụng |
| expected_users | INT | Số người dự kiến |
| status | VARCHAR(20) | Trạng thái (pending/approved/rejected/cancelled/completed) |
| reject_reason | VARCHAR(500) | Lý do từ chối |
| processed_by | INT (FK) | Người duyệt |
| processed_at | TIMESTAMP | Thời gian duyệt |
| created_at | TIMESTAMP | Ngày tạo |
| updated_at | TIMESTAMP | Ngày cập nhật |

#### 5. `incident_tickets` - Sự cố
| Trường | Kiểu | Mô tả |
|--------|------|-------|
| id | INT (PK) | ID sự cố |
| reporter_id | INT (FK) | Người báo cáo |
| workstation_id | INT (FK) | Máy liên quan (nếu có) |
| lab_room_id | INT (FK) | Phòng liên quan (nếu có) |
| category | VARCHAR(20) | Loại sự cố (hardware/network/os/software) |
| description | TEXT | Mô tả sự cố |
| status | VARCHAR(20) | Trạng thái (open/under_review/resolved/closed) |
| assigned_to | INT (FK) | Người được giao |
| resolution_note | TEXT | Ghi chú xử lý |
| created_at | TIMESTAMP | Ngày tạo |
| updated_at | TIMESTAMP | Ngày cập nhật |
| resolved_at | TIMESTAMP | Ngày giải quyết |

#### 6. `refresh_tokens` - Token làm mới
| Trường | Kiểu | Mô tả |
|--------|------|-------|
| id | INT (PK) | ID token |
| user_id | INT (FK) | Người dùng |
| token_hash | CHAR(64) | Hash của refresh token |
| expires_at | TIMESTAMP | Thời hạn |
| created_at | TIMESTAMP | Ngày tạo |

#### 7. `password_reset_tokens` - Token đặt lại mật khẩu
| Trường | Kiểu | Mô tả |
|--------|------|-------|
| id | INT (PK) | ID token |
| user_id | INT (FK) | Người dùng |
| token_hash | CHAR(64) | Hash của token |
| expires_at | TIMESTAMP | Thời hạn |
| used | BOOLEAN | Đã sử dụng |
| created_at | TIMESTAMP | Ngày tạo |

### Ràng buộc đặc biệt

#### Exclusion Constraint (Chống trùng lịch)
```sql
-- Ngăn chặn đặt chỗ trùng thời gian cho cùng 1 phòng lab
ALTER TABLE reservations ADD CONSTRAINT reservations_no_overlap_lab
  EXCLUDE USING gist (
    lab_room_id WITH =,
    tsrange(start_time, end_time, '[)') WITH &&
  )
  WHERE (status = 'approved' AND lab_room_id IS NOT NULL);

-- Ngăn chặn đặt chỗ trùng thời gian cho cùng 1 máy trạm
ALTER TABLE reservations ADD CONSTRAINT reservations_no_overlap_ws
  EXCLUDE USING gist (
    workstation_id WITH =,
    tsrange(start_time, end_time, '[)') WITH &&
  )
  WHERE (status = 'approved' AND workstation_id IS NOT NULL);
```

### Dữ liệu mẫu (Seed)

- **15 users**: 1 admin, 4 lab_staff, 10 customers
- **7 lab rooms**: LAB-A101 đến LAB-E501
- **35 workstations**: 5 máy/phòng
- **Đặt chỗ mẫu**: Với nhiều trạng thái khác nhau
- **Sự cố mẫu**: Các loại sự cố khác nhau

**Tài khoản demo:**
| Username | Password | Vai trò |
|----------|----------|---------|
| admin | Admin@1234 | System Admin |
| staff1 | Test@1234 | Lab Staff |
| user1 | Test@1234 | Customer |

---

## Frontend

### Cấu trúc thư mục

```
Frontend/
├── src/
│   ├── components/
│   │   ├── layout/          # Layout components
│   │   │   ├── AppLayout.jsx
│   │   │   ├── Sidebar.jsx
│   │   │   └── Topbar.jsx
│   │   └── ui/              # UI components
│   │       ├── Badge.jsx
│   │       ├── Loader.jsx
│   │       ├── Modal.jsx
│   │       └── Pagination.jsx
│   ├── pages/
│   │   ├── auth/            # Authentication pages
│   │   │   ├── AuthLayout.jsx
│   │   │   ├── LoginPage.jsx
│   │   │   ├── RegisterPage.jsx
│   │   │   ├── VerifyEmailPage.jsx
│   │   │   ├── ForgotPasswordPage.jsx
│   │   │   └── ResetPasswordPage.jsx
│   │   ├── labrooms/        # Lab room pages
│   │   │   ├── LabRoomsPage.jsx
│   │   │   └── LabRoomDetailPage.jsx
│   │   ├── workstations/     # Workstation pages
│   │   │   ├── WorkstationsPage.jsx
│   │   │   └── WorkstationDetailPage.jsx
│   │   ├── reservations/     # Reservation pages
│   │   │   ├── MyReservationsPage.jsx
│   │   │   └── ReservationQueuePage.jsx
│   │   ├── incidents/       # Incident pages
│   │   │   ├── IncidentsPage.jsx
│   │   │   └── IncidentDetailPage.jsx
│   │   ├── admin/           # Admin pages
│   │   │   ├── UsersPage.jsx
│   │   │   └── ReportsPage.jsx
│   │   ├── DashboardPage.jsx
│   │   └── ProfilePage.jsx
│   ├── services/
│   │   └── authService.js   # API service layer
│   ├── store/
│   │   └── authStore.js     # Zustand state management
│   ├── lib/
│   │   ├── api.js           # Axios configuration
│   │   ├── auth.jsx         # Auth components & hooks
│   │   └── utils.js         # Utility functions
│   ├── App.jsx              # Main app with routing
│   ├── main.jsx             # Entry point
│   └── index.css            # Global styles
├── index.html
├── package.json
├── vite.config.js
├── tailwind.config.js
└── postcss.config.js
```

### Các thành phần chính

#### `src/App.jsx` - Routing
- Định nghĩa tất cả routes của ứng dụng
- Sử dụng `ProtectedRoute` cho các trang cần đăng nhập
- Sử dụng `GuestRoute` cho trang đăng nhập/đăng ký
- Kiểm soát quyền truy cập theo vai trò

#### `src/lib/api.js` - Axios Configuration
- Tạo axios instance với baseURL `/api`
- Interceptor thêm JWT token vào header
- Xử lý tự động refresh token khi hết hạn
- Export helper function `apiMessage()` để lấy thông báo lỗi

#### `src/store/authStore.js` - State Management (Zustand)
```javascript
{
  accessToken: null,  // JWT access token
  user: null,         // User profile data
  setSession(),       // Set both token and user
  setAccessToken(),   // Update token only
  setUser(),         // Update user only
  clear()            // Logout - clear all
}
```

#### `src/services/authService.js` - API Service Layer
Cung cấp các API methods cho:
- `authApi`: Đăng nhập, đăng ký, xác thực, đặt lại mật khẩu
- `userApi`: Quản lý người dùng
- `labRoomApi`: Quản lý phòng lab
- `workstationApi`: Quản lý máy trạm
- `reservationApi`: Quản lý đặt chỗ
- `incidentApi`: Quản lý sự cố
- `reportApi`: Báo cáo thống kê

---

## Tính năng chính

### 1. Xác thực & Ủy quyền

- **Đăng ký**: Tạo tài khoản mới với xác thực email
- **Đăng nhập**: Với cơ chế khóa tài khoản khi đăng nhập sai nhiều lần
- **Xác thực Email (OTP)**: Mã 6 số có thời hạn 5 phút
- **Đặt lại mật khẩu**: Qua email với OTP
- **JWT Authentication**: Access token (15 phút) + Refresh token (7 ngày)
- **Phân quyền theo vai trò**: Customer, Lab Staff, System Admin

### 2. Quản lý Phòng Lab

- Xem danh sách phòng lab
- Xem chi tiết phòng lab (vị trí, số máy, máy trạm)
- Tạo/Cập nhật/Xóa phòng lab (System Admin)
- Lọc theo trạng thái (active/maintenance/decommissioned)

### 3. Quản lý Máy trạm

- Xem danh sách máy trạm theo phòng
- Xem chi tiết máy trạm (cấu hình, IP, MAC, OS)
- Cập nhật trạng thái máy trạm
- Tạo/Cập nhật/Xóa máy trạm (System Admin)
- Lọc theo trạng thái (available/maintenance/reserved)

### 4. Hệ thống Đặt chỗ

- **Đặt phòng lab**: Chọn phòng, khung giờ, số người, mục đích
- **Đặt máy trạm**: Chọn máy cụ thể, khung giờ
- **Chống trùng lịch**: Database constraint ngăn đặt trùng thời gian
- **Duyệt đặt chỗ**: Lab Staff/System Admin duyệt hoặc từ chối
- **Hủy đặt chỗ**: Người dùng tự hủy đặt chỗ của mình
- **Xem lịch sử**: Tất cả đặt chỗ của người dùng

### 5. Quản lý Sự cố

- **Tạo ticket**: Báo cáo sự cố về phần cứng, mạng, OS, phần mềm
- **Gán xử lý**: Lab Staff tiếp nhận xử lý
- **Cập nhật trạng thái**: open → under_review → resolved → closed
- **Ghi chú xử lý**: Ghi lại cách giải quyết

### 6. Báo cáo & Thống kê

- Thống kê tổng quan (số phòng, máy, đặt chỗ, sự cố)
- Báo cáo sử dụng theo ngày/tháng
- Xuất dữ liệu báo cáo (System Admin)

---

## Vai trò người dùng

### 1. Customer (Khách hàng)
- Đăng ký, đăng nhập, quản lý profile
- Xem phòng lab và máy trạm
- Đặt chỗ phòng/máy
- Xem và hủy đặt chỗ của mình
- Báo cáo sự cố

### 2. Lab Staff (Nhân viên lab)
- Tất cả quyền của Customer
- Xem hàng chờ đặt chỗ
- Duyệt/từ chối đặt chỗ
- Xem danh sách sự cố
- Tiếp nhận và xử lý sự cố

### 3. System Admin (Quản trị viên)
- Tất cả quyền của Lab Staff
- Quản lý người dùng (block/unblock)
- Tạo/Cập nhật/Xóa phòng lab
- Tạo/Cập nhật/Xóa máy trạm
- Xem báo cáo thống kê
- Xuất báo cáo

---

## API Endpoints

### Authentication (`/api/auth`)
| Method | Endpoint | Mô tả |
|--------|----------|-------|
| POST | /register | Đăng ký tài khoản mới |
| POST | /verify-email | Xác thực email bằng OTP |
| POST | /resend-verification | Gửi lại mã xác thực |
| POST | /login | Đăng nhập |
| POST | /refresh-token | Làm mới access token |
| POST | /forgot-password | Yêu cầu đặt lại mật khẩu |
| POST | /reset-password | Đặt lại mật khẩu bằng OTP |
| POST | /logout | Đăng xuất |
| PUT | /change-password | Đổi mật khẩu |

### Users (`/api/users`)
| Method | Endpoint | Quyền | Mô tả |
|--------|----------|-------|-------|
| GET | / | Admin | Lấy danh sách users |
| GET | /me | All | Lấy profile hiện tại |
| PUT | /me | All | Cập nhật profile |
| GET | /:id | Admin | Lấy thông tin user |
| PATCH | /:id/block | Admin | Khóa tài khoản |
| PATCH | /:id/unblock | Admin | Mở khóa tài khoản |

### Lab Rooms (`/api/lab-rooms`)
| Method | Endpoint | Quyền | Mô tả |
|--------|----------|-------|-------|
| GET | / | All | Lấy danh sách phòng lab |
| GET | /:id | All | Lấy chi tiết phòng lab |
| POST | / | Admin | Tạo phòng lab mới |
| PUT | /:id | Admin | Cập nhật phòng lab |
| DELETE | /:id | Admin | Xóa phòng lab |

### Workstations (`/api/workstations`)
| Method | Endpoint | Quyền | Mô tả |
|--------|----------|-------|-------|
| GET | / | All | Lấy danh sách máy trạm |
| GET | /:id | All | Lấy chi tiết máy trạm |
| POST | / | Admin | Tạo máy trạm mới |
| PUT | /:id | Admin | Cập nhật máy trạm |
| PATCH | /:id/state | Staff/Admin | Cập nhật trạng thái |
| DELETE | /:id | Admin | Xóa máy trạm |

### Reservations (`/api/reservations`)
| Method | Endpoint | Quyền | Mô tả |
|--------|----------|-------|-------|
| GET | /my | All | Đặt chỗ của tôi |
| GET | /queue | Staff/Admin | Hàng chờ duyệt |
| GET | /:id | All | Chi tiết đặt chỗ |
| POST | /lab-room | All | Đặt phòng lab |
| POST | /workstation | All | Đặt máy trạm |
| PATCH | /:id/cancel | All | Hủy đặt chỗ |
| PATCH | /:id/approve | Staff/Admin | Duyệt đặt chỗ |
| PATCH | /:id/reject | Staff/Admin | Từ chối đặt chỗ |

### Incidents (`/api/incidents`)
| Method | Endpoint | Quyền | Mô tả |
|--------|----------|-------|-------|
| GET | / | Staff/Admin | Danh sách sự cố |
| GET | /:id | All | Chi tiết sự cố |
| POST | / | All | Tạo ticket sự cố |
| PATCH | /:id/status | Staff/Admin | Cập nhật trạng thái |

### Reports (`/api/reports`)
| Method | Endpoint | Quyền | Mô tả |
|--------|----------|-------|-------|
| GET | / | Admin | Xuất báo cáo |

---

## Công nghệ sử dụng

### Backend
| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| Node.js | - | Runtime environment |
| Express.js | ^4.21.0 | Web framework |
| Prisma | ^6.7.0 | ORM cho PostgreSQL |
| PostgreSQL | - | Database |
| JWT | ^9.0.2 | Xác thực |
| bcryptjs | ^2.4.3 | Mã hóa mật khẩu |
| express-validator | ^7.2.0 | Validation |
| express-rate-limit | ^7.4.0 | Rate limiting |
| nodemailer | ^6.9.15 | Gửi email |
| swagger-ui-express | ^5.0.1 | API documentation |
| cors | ^2.8.5 | CORS handling |
| cookie-parser | ^1.4.7 | Cookie parsing |

### Frontend
| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| React | ^18.3.1 | UI framework |
| Vite | ^5.4.8 | Build tool |
| React Router | ^6.27.0 | Routing |
| Zustand | ^5.0.0 | State management |
| Axios | ^1.7.7 | HTTP client |
| TailwindCSS | ^3.4.13 | CSS framework |
| Lucide React | ^0.453.0 | Icons |
| date-fns | ^4.1.0 | Date formatting |
| react-hot-toast | ^2.4.1 | Toast notifications |
| clsx | ^2.1.1 | Class name utility |

---

## Cài đặt và chạy

### Yêu cầu

- Node.js >= 18
- mysql
- npm hoặc yarn

### 1. Backend Setup

```bash
# Di chuyển vào thư mục Backend
cd Backend

# Cài đặt dependencies
npm install

# Tạo file .env từ .env.example
cp .env.example .env

# Chỉnh sửa .env với thông tin database của bạn
# DATABASE_URL=postgresql://user:password@localhost:5432/clms_db

# Khởi tạo Prisma client
npm run prisma:generate

# Chạy server (sẽ tự động tạo database schema)
npm run dev
```

### 2. Frontend Setup

```bash
# Di chuyển vào thư mục Frontend (terminal mới)
cd Frontend

# Cài đặt dependencies
npm install

# Chạy development server
npm run dev
```

### 3. Truy cập

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000
- **Swagger Docs**: http://localhost:5000/api/docs
- **OpenAPI JSON**: http://localhost:5000/api/openapi.json

### 4. Tài khoản Demo

Sau khi chạy seed, đăng nhập với:

| Username | Password | Vai trò |
|----------|----------|---------|
| admin | Admin@1234 | System Admin |
| staff1 | Test@1234 | Lab Staff |
| user1 | Test@1234 | Customer |

---

## Cấu hình môi trường (.env)

```bash
# Server
PORT=5000
NODE_ENV=development

# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=clms
DB_PASSWORD=clms_dev
DB_NAME=clms_db

# JWT
JWT_ACCESS_SECRET=your_access_secret
JWT_REFRESH_SECRET=your_refresh_secret
JWT_ACCESS_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d

# OTP
OTP_TTL_MINUTES=5

# Account Lock
LOGIN_MAX_ATTEMPTS=5
LOGIN_LOCK_MINUTES=30

# Rate Limit
RATE_LIMIT_WINDOW_MS=60000
RATE_LIMIT_MAX=100

# CORS
ALLOWED_ORIGINS=http://localhost:3000

# Email (Gmail)
EMAIL_SERVICE=gmail
EMAIL_USER=your_email@gmail.com
EMAIL_PASS=your_app_password
EMAIL_FROM=CLMS <your_email@gmail.com>
```

---

## Tài liệu API

Swagger UI được tích hợp sẵn tại `/api/docs` cung cấp:

- Danh sách tất cả endpoints
- Mô tả parameters và request body
- Response schemas
- Khả năng test trực tiếp trên giao diện

---

## Bảo mật

1. **Mật khẩu**: Băm bằng bcrypt (10 rounds)
2. **JWT**: Access token ngắn hạn (15p), Refresh token dài hạn (7 days)
3. **Rate Limiting**: Giới hạn 100 requests/phút cho API
4. **Account Locking**: Khóa 30 phút sau 5 lần đăng nhập sai
5. **Validation**: Input validation ở cả backend và frontend
6. **CORS**: Chỉ cho phép origin được cấu hình
7. **Cookie Security**: HttpOnly cookies cho refresh token
