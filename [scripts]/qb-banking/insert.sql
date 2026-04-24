-- Joint accounts
CREATE TABLE IF NOT EXISTS joint_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_name VARCHAR(50) NOT NULL,
    balance INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS joint_account_members (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    citizenid VARCHAR(50) NOT NULL,
    FOREIGN KEY (account_id) REFERENCES joint_accounts(id) ON DELETE CASCADE
);

-- Society accounts
CREATE TABLE IF NOT EXISTS society_accounts (
    job VARCHAR(50) PRIMARY KEY,
    balance INT NOT NULL DEFAULT 0
);
