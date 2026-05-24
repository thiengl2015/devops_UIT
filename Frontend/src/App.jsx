import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { Toaster } from 'react-hot-toast';

// TODO: Import pages and components after scaffolding
// import AppLayout from './components/layout/AppLayout';
// import LoginPage from './pages/auth/LoginPage';
// import DashboardPage from './pages/DashboardPage';

function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* TODO: Add routes */}
        {/* <Route path="/login" element={<LoginPage />} /> */}
        {/* <Route path="/" element={<AppLayout />}></Route> */}
      </Routes>
      <Toaster position="top-right" />
    </BrowserRouter>
  );
}

export default App;
