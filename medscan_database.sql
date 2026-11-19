-- ============================================================================
-- MED SCAN (ميد سكان للأشعة والتحاليل) - قاعدة بيانات الحضور والساعات والخصومات
-- العنوان: 43 ش العزيز بالله - الزيتون - القاهرة | ت: 01281088667
-- ============================================================================

CREATE TABLE IF NOT EXISTS settings (
    id INTEGER PRIMARY KEY,
    branch_name VARCHAR(255) NOT NULL DEFAULT 'ميد سكان للأشعة والتحاليل - 43 ش العزيز بالله - الزيتون',
    lat DOUBLE NOT NULL DEFAULT 30.0886,
    lng DOUBLE NOT NULL DEFAULT 31.3094,
    allowed_radius_meters INTEGER NOT NULL DEFAULT 100,
    grace_minutes INTEGER NOT NULL DEFAULT 15,
    rounding_mode VARCHAR(50) NOT NULL DEFAULT 'ceil_full'
);

INSERT INTO settings (id, branch_name, lat, lng, allowed_radius_meters, grace_minutes, rounding_mode)
VALUES (1, 'ميد سكان للأشعة والتحاليل - 43 ش العزيز بالله - الزيتون', 30.0886, 31.3094, 100, 15, 'ceil_full');

CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(64) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) DEFAULT '',
    role VARCHAR(32) NOT NULL DEFAULT 'employee',
    activated INTEGER NOT NULL DEFAULT 0,
    title VARCHAR(255) NOT NULL DEFAULT '',
    hourly_rate DOUBLE NOT NULL DEFAULT 100,
    worked_days INTEGER NOT NULL DEFAULT 26,
    shift_start VARCHAR(10) NOT NULL DEFAULT '09:00',
    shift_end VARCHAR(10) NOT NULL DEFAULT '17:00',
    exempt_from_deductions INTEGER NOT NULL DEFAULT 0, -- 1 = إلغاء الخصم لهذا الموظف
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (id, name, email, password, role, activated, title, hourly_rate, worked_days, shift_start, shift_end, exempt_from_deductions)
VALUES
('u_admin', 'إدارة ميد سكان', 'admin@medscan.com', '1234', 'admin', 1, 'مدير النظام', 150, 26, '09:00', '17:00', 1),
('u_sup', 'مشرف فرع ميد سكان', 'supervisor@medscan.com', '1234', 'supervisor', 1, 'مشرف فرع الزيتون', 120, 26, '09:00', '17:00', 0),
('u_emp1', 'أحمد طارق', 'ahmed@medscan.com', '1234', 'employee', 1, 'أخصائي أشعة تشخيصية', 100, 26, '09:00', '17:00', 0);

CREATE TABLE IF NOT EXISTS early_departure_requests (
    id VARCHAR(64) PRIMARY KEY,
    user_id VARCHAR(64) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    request_time VARCHAR(16) NOT NULL,
    shift_end VARCHAR(16) NOT NULL,
    reason TEXT NOT NULL,
    status VARCHAR(32) NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS attendance_logs (
    id VARCHAR(64) PRIMARY KEY,
    user_id VARCHAR(64) NOT NULL,
    user_name VARCHAR(255) NOT NULL,
    action_type VARCHAR(10) NOT NULL,
    date_str VARCHAR(20) NOT NULL,
    time_str VARCHAR(20) NOT NULL,
    shift_start VARCHAR(10) NOT NULL,
    shift_end VARCHAR(10) NOT NULL,
    lat DOUBLE NOT NULL,
    lng DOUBLE NOT NULL,
    distance_meters INTEGER NOT NULL,
    late_minutes INTEGER NOT NULL DEFAULT 0,
    within_grace INTEGER NOT NULL DEFAULT 1,
    deducted_hours DOUBLE NOT NULL DEFAULT 0,
    deduction_amount DOUBLE NOT NULL DEFAULT 0,
    deduction_waived INTEGER NOT NULL DEFAULT 0, -- 1 = تم إلغاء الخصم عن هذه الحركة
    early_reason TEXT DEFAULT '',
    photo_data_url LONGTEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
