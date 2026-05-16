-- ================================================
-- COMPLETE FIX SCRIPT
-- Clears everything and reinserts correctly
-- ================================================

USE CyberSOC_Pro;
GO

-- ================================================
-- STEP 1: DISABLE ALL FOREIGN KEY CHECKS
-- This allows us to delete in any order
-- ================================================
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- ================================================
-- STEP 2: DELETE ALL DATA FROM ALL TABLES
-- ================================================
DELETE FROM case_notes;
DELETE FROM reports;
DELETE FROM activity_log;
DELETE FROM threat_alerts;
DELETE FROM ai_recommendations;
DELETE FROM ai_analysis;
DELETE FROM custody_log;
DELETE FROM suspects;
DELETE FROM evidence;
DELETE FROM incidents;
DELETE FROM cases;
DELETE FROM users;
GO

-- ================================================
-- STEP 3: RESET ALL IDENTITY COUNTERS
-- ================================================
DBCC CHECKIDENT ('users',              RESEED, 0);
DBCC CHECKIDENT ('cases',              RESEED, 0);
DBCC CHECKIDENT ('incidents',          RESEED, 0);
DBCC CHECKIDENT ('evidence',           RESEED, 0);
DBCC CHECKIDENT ('suspects',           RESEED, 0);
DBCC CHECKIDENT ('custody_log',        RESEED, 0);
DBCC CHECKIDENT ('ai_analysis',        RESEED, 0);
DBCC CHECKIDENT ('ai_recommendations', RESEED, 0);
DBCC CHECKIDENT ('threat_alerts',      RESEED, 0);
DBCC CHECKIDENT ('activity_log',       RESEED, 0);
DBCC CHECKIDENT ('reports',            RESEED, 0);
DBCC CHECKIDENT ('case_notes',         RESEED, 0);
GO

-- ================================================
-- STEP 4: RE-ENABLE ALL FOREIGN KEY CHECKS
-- ================================================
EXEC sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL';
GO

PRINT 'All tables cleared! Now inserting fresh data...';
GO

-- ================================================
-- TABLE 1: users (INSERT FIRST - parent table)
-- ================================================
INSERT INTO users
(user_id, username, password_hash, role,
 full_name, email, last_login, is_active)
VALUES
('USR-2024-00001','tariq.admin','e3b0c44298fc1c149afbf4c8996fb924','Admin','Tariq Ahmad','tariq.ahmad@cybersoc.pk','2024-01-15 08:30:00',1),
('USR-2024-00002','ali.hassan','a665a45920422f9d417e4867efdc4fb8','Admin','Ali Hassan','ali.hassan@cybersoc.pk','2024-01-15 09:00:00',1),
('USR-2024-00003','sara.ahmed','b3a8e0e1f9ab1bfe3a36f231f676f78e','Analyst','Sara Ahmed','sara.ahmed@cybersoc.pk','2024-01-14 10:15:00',1),
('USR-2024-00004','omar.khan','c5f7a8b2d4e6f1a3c9b7e5d3f2a4c6b8','Analyst','Omar Khan','omar.khan@cybersoc.pk','2024-01-14 11:30:00',1),
('USR-2024-00005','fatima.malik','d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9','Analyst','Fatima Malik','fatima.malik@cybersoc.pk','2024-01-13 09:45:00',1),
('USR-2024-00006','hassan.raza','e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0','Analyst','Hassan Raza','hassan.raza@cybersoc.pk','2024-01-13 14:20:00',1),
('USR-2024-00007','ayesha.noor','f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1','Analyst','Ayesha Noor','ayesha.noor@cybersoc.pk','2024-01-12 08:00:00',1),
('USR-2024-00008','bilal.qureshi','a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2','Analyst','Bilal Qureshi','bilal.qureshi@cybersoc.pk','2024-01-12 13:10:00',1),
('USR-2024-00009','zara.hussain','b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3','Analyst','Zara Hussain','zara.hussain@cybersoc.pk','2024-01-11 10:30:00',1),
('USR-2024-00010','kamran.shah','c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4','Analyst','Kamran Shah','kamran.shah@cybersoc.pk','2023-12-01 09:00:00',0);
GO
PRINT 'users: 10 rows inserted!';
GO

-- ================================================
-- TABLE 2: cases (needs users)
-- assigned_to and created_by = users.id (1-10)
-- ================================================
INSERT INTO cases
(case_id, title, case_type, status, priority,
 opened_date, closed_date, assigned_to, created_by, description)
VALUES
('CASE-2024-00001','SQL Injection Attack on HBL Bank','Cybercrime','Investigating','Critical','2024-01-10',NULL,3,1,'Attacker exploited login form to access customer records'),
('CASE-2024-00002','Phishing Campaign Targeting Jazz Users','Fraud','Open','High','2024-01-12',NULL,4,1,'Mass phishing emails sent to Jazz customers stealing credentials'),
('CASE-2024-00003','Ransomware Attack on FBR Server','Malware','Investigating','Critical','2024-01-13',NULL,5,2,'FBR tax system encrypted by ransomware demanding Bitcoin payment'),
('CASE-2024-00004','Unauthorized Access to NADRA Database','Cybercrime','Closed','High','2024-01-05','2024-01-20',6,1,'Insider threat gained unauthorized access to citizen records'),
('CASE-2024-00005','DDoS Attack on Punjab Police Website','Cybercrime','Closed','Medium','2024-01-08','2024-01-15',7,2,'Distributed denial of service attack took website offline for 6 hours'),
('CASE-2024-00006','Data Breach at Telenor Pakistan','Fraud','Investigating','Critical','2024-01-15',NULL,3,1,'Customer data including CNICs leaked on dark web forum'),
('CASE-2024-00007','Brute Force Attack on MCB Internet Banking','Cybercrime','Open','High','2024-01-16',NULL,4,2,'Automated tool attempting thousands of login combinations per minute'),
('CASE-2024-00008','Malware Infection on Government Computers','Malware','Investigating','High','2024-01-17',NULL,5,1,'Trojan horse malware spread through USB drives in government offices'),
('CASE-2024-00009','Social Engineering Attack on PTCL','Fraud','Open','Medium','2024-01-18',NULL,6,2,'Attacker impersonated IT support to steal employee credentials'),
('CASE-2024-00010','Cryptojacking on University Servers','Cybercrime','Closed','Low','2024-01-03','2024-01-25',7,1,'Unauthorized cryptocurrency mining software found on university servers'),
('CASE-2024-00011','Spear Phishing Attack on Minister Office','Fraud','Investigating','Critical','2024-01-19',NULL,8,2,'Targeted phishing email sent to minister office staff with malicious attachment'),
('CASE-2024-00012','Zero Day Exploit on Apache Server','Cybercrime','Open','Critical','2024-01-20',NULL,9,1,'Unknown vulnerability exploited in Apache web server version 2.4'),
('CASE-2024-00013','Insider Data Theft at Meezan Bank','Fraud','Investigating','High','2024-01-21',NULL,3,2,'Bank employee copying customer financial data to personal USB'),
('CASE-2024-00014','Botnet Activity Detected on ISP Network','Cybercrime','Open','Medium','2024-01-22',NULL,4,1,'Large number of infected machines sending spam from ISP network'),
('CASE-2024-00015','Identity Theft Ring Discovered','Fraud','Investigating','High','2024-01-23',NULL,5,2,'Organized group using stolen CNICs to open fake bank accounts');
GO
PRINT 'cases: 15 rows inserted!';
GO

-- ================================================
-- TABLE 3: incidents (needs cases + users)
-- case_id = cases.id (1-15)
-- reported_by = users.id (1-10)
-- ================================================
INSERT INTO incidents
(incident_id, case_id, event_type, source_ip, target_ip,
 severity, status, description, reported_by, timestamp)
VALUES
('INC-2024-00001',1,'SQL Injection','185.220.101.45','10.0.0.15','Critical','Investigating','Malicious SQL code injected through login form parameter',3,'2024-01-10 03:22:00'),
('INC-2024-00002',1,'Data Exfiltration','185.220.101.45','10.0.0.15','Critical','Investigating','Attacker dumped entire customer database table',3,'2024-01-10 03:45:00'),
('INC-2024-00003',2,'Phishing Email','192.168.50.100','0.0.0.0','High','Open','Bulk phishing emails sent from compromised mail server',4,'2024-01-12 08:00:00'),
('INC-2024-00004',2,'Credential Theft','192.168.50.100','0.0.0.0','High','Open','Stolen credentials being sold on dark web marketplace',4,'2024-01-12 14:30:00'),
('INC-2024-00005',3,'Ransomware','91.108.4.200','172.16.0.5','Critical','Investigating','WannaCry variant ransomware encrypting all server files',5,'2024-01-13 02:15:00'),
('INC-2024-00006',3,'Lateral Movement','91.108.4.200','172.16.0.0','Critical','Investigating','Ransomware spreading across internal network segments',5,'2024-01-13 02:30:00'),
('INC-2024-00007',4,'Unauthorized Access','10.10.10.55','192.168.1.100','High','Resolved','Insider accessed restricted database using admin credentials',6,'2024-01-05 11:00:00'),
('INC-2024-00008',5,'DDoS','Multiple','202.83.47.10','Medium','Resolved','Over 50000 requests per second hitting web server',7,'2024-01-08 15:00:00'),
('INC-2024-00009',6,'Data Breach','Unknown','10.20.30.40','Critical','Investigating','Customer CNIC and contact data found on Telegram channel',3,'2024-01-15 09:00:00'),
('INC-2024-00010',7,'Brute Force','45.33.32.156','203.128.12.5','High','Open','5000 failed login attempts detected in 10 minutes',4,'2024-01-16 04:00:00'),
('INC-2024-00011',7,'Account Lockout','45.33.32.156','203.128.12.5','Medium','Open','Multiple customer accounts locked due to brute force',4,'2024-01-16 04:15:00'),
('INC-2024-00012',8,'Trojan','Unknown','192.168.5.0','High','Investigating','Trojan horse detected on 15 government workstations',5,'2024-01-17 10:00:00'),
('INC-2024-00013',9,'Social Engineering','N/A','N/A','Medium','Open','Employee tricked into revealing VPN credentials over phone',6,'2024-01-18 13:00:00'),
('INC-2024-00014',10,'Cryptojacking','198.54.117.197','10.5.0.20','Low','Resolved','XMRig cryptocurrency miner found running on 8 servers',7,'2024-01-03 08:00:00'),
('INC-2024-00015',11,'Spear Phishing','Unknown','N/A','Critical','Investigating','Email with malicious PDF attachment opened by staff member',8,'2024-01-19 11:30:00'),
('INC-2024-00016',11,'Malware Execution','Unknown','10.30.0.5','Critical','Investigating','Malicious macro in PDF executed downloading backdoor',8,'2024-01-19 11:35:00'),
('INC-2024-00017',12,'Zero Day Exploit','77.88.55.80','10.0.1.5','Critical','Open','Unknown exploit used against Apache 2.4 server',9,'2024-01-20 00:30:00'),
('INC-2024-00018',13,'Insider Threat','10.10.5.55','N/A','High','Investigating','Employee copying files to USB drive after hours',3,'2024-01-21 19:00:00'),
('INC-2024-00019',14,'Botnet','Multiple','N/A','Medium','Open','2000 infected machines sending spam emails through ISP',4,'2024-01-22 07:00:00'),
('INC-2024-00020',15,'Identity Fraud','N/A','N/A','High','Investigating','Fake CNICs used to open 50 fraudulent bank accounts',5,'2024-01-23 10:00:00'),
('INC-2024-00021',1,'Port Scan','185.220.101.45','10.0.0.0','Medium','Resolved','Port scan conducted before SQL injection attack',3,'2024-01-09 23:00:00'),
('INC-2024-00022',6,'Dark Web Listing','Unknown','N/A','High','Investigating','Company data listed for sale on dark web forum',3,'2024-01-16 08:00:00'),
('INC-2024-00023',3,'Backup Deletion','91.108.4.200','172.16.0.5','Critical','Investigating','Ransomware deleted all backup files before encrypting',5,'2024-01-13 03:00:00'),
('INC-2024-00024',8,'Keylogger','Unknown','192.168.5.10','High','Investigating','Keylogger software recording all keystrokes on infected PCs',5,'2024-01-17 12:00:00'),
('INC-2024-00025',12,'Privilege Escalation','77.88.55.80','10.0.1.5','Critical','Open','Attacker gained root access after exploiting Apache',9,'2024-01-20 01:00:00');
GO
PRINT 'incidents: 25 rows inserted!';
GO

-- ================================================
-- TABLE 4: evidence (needs cases + users)
-- ================================================
INSERT INTO evidence
(evidence_id, case_id, evidence_type, description,
 file_hash, collected_by, is_verified)
VALUES
('EVD-2024-00001',1,'Log File','Apache access log showing SQL injection attempts','a3f5c2d1e4b6a7c8d9e0f1a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b1',3,1),
('EVD-2024-00002',1,'Screenshot','Screenshot of attacker database dump output','b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4',3,1),
('EVD-2024-00003',2,'Email Sample','Phishing email with malicious link collected','c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5',4,1),
('EVD-2024-00004',3,'Malware Sample','WannaCry ransomware binary file collected','d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6',5,1),
('EVD-2024-00005',3,'Network Dump','Wireshark capture of ransomware network traffic','e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7',5,0),
('EVD-2024-00006',4,'Access Log','Database access log showing unauthorized queries','f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8',6,1),
('EVD-2024-00007',5,'Server Log','Web server log showing DDoS traffic pattern','a9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9',7,1),
('EVD-2024-00008',6,'Dark Web Screenshot','Screenshot of data listing on dark web forum','b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0',3,0),
('EVD-2024-00009',7,'Firewall Log','Firewall log showing blocked brute force IPs','c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1',4,1),
('EVD-2024-00010',8,'Malware Sample','Trojan horse executable collected from infected PC','d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2',5,1),
('EVD-2024-00011',9,'Call Recording','Phone call recording of social engineering attempt','e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3',6,0),
('EVD-2024-00012',10,'Process List','Running process list showing cryptominer activity','f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4',7,1),
('EVD-2024-00013',11,'Email Header','Full email header analysis of spear phishing email','a5b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5',8,1),
('EVD-2024-00014',11,'Malware Sample','Backdoor malware downloaded by phishing email macro','b6c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6',8,0),
('EVD-2024-00015',12,'Exploit Code','Zero day exploit code recovered from server memory','c7d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7',9,1),
('EVD-2024-00016',13,'CCTV Footage','CCTV recording of employee copying files to USB','d8e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8',3,1),
('EVD-2024-00017',13,'USB Image','Forensic image of USB drive containing stolen data','e9f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9',3,1),
('EVD-2024-00018',14,'Network Log','ISP network log showing botnet command traffic','f0a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0',4,0),
('EVD-2024-00019',15,'Bank Records','Fraudulent bank account opening documents','a1b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1',5,1),
('EVD-2024-00020',6,'Memory Dump','RAM dump from compromised Telenor server','b2c3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1b2',3,0);
GO
PRINT 'evidence: 20 rows inserted!';
GO

-- ================================================
-- TABLE 5: suspects (needs cases + users)
-- ================================================
INSERT INTO suspects
(suspect_id, case_id, name, ip_address,
 device_info, risk_score, notes, added_by)
VALUES
('SUS-2024-00001',1,'Unknown Attacker','185.220.101.45','Tor Browser on Linux Kali',95,'IP traced to Tor exit node in Germany. Highly sophisticated attack.',3),
('SUS-2024-00002',2,'Phishing Group','192.168.50.100','Unknown — spoofed headers',80,'Organized phishing group. Similar attacks reported in UAE and Saudi Arabia.',4),
('SUS-2024-00003',3,'RansomGroup47','91.108.4.200','Windows 10 — VPN detected',90,'Known ransomware group. Previously attacked hospitals in Europe.',5),
('SUS-2024-00004',4,'Ahmed Raza','10.10.10.55','Windows 11 — Office PC',85,'Bank employee with admin access. Found with unauthorized USB drive.',6),
('SUS-2024-00005',5,'Unknown Group','Multiple IPs','Botnet — multiple countries',70,'DDoS attack launched from botnet of 10000 infected machines.',7),
('SUS-2024-00006',6,'Unknown','Unknown','Unknown — data already leaked',75,'Data breach source still under investigation.',3),
('SUS-2024-00007',7,'AutoBrute Tool','45.33.32.156','Automated script on Linux',65,'Automated brute force tool. Linked to previous bank attacks.',4),
('SUS-2024-00008',8,'Unknown Insider','10.10.5.55','Government PC Windows 10',72,'Malware spread via USB. Insider involvement suspected.',5),
('SUS-2024-00009',9,'Unknown Caller','N/A','Phone call — untraceable',60,'Social engineering via phone. Voice disguised.',6),
('SUS-2024-00010',10,'CryptoMiner Script','198.54.117.197','Linux server — automated',45,'Cryptojacking script deployed through vulnerable WordPress plugin.',7),
('SUS-2024-00011',11,'APT Group','Unknown','Advanced persistent threat',92,'State sponsored APT group suspected. Highly targeted attack.',8),
('SUS-2024-00012',12,'Zero Day Seller','77.88.55.80','Unknown — heavily encrypted',88,'Suspected zero day exploit purchased from dark web.',9),
('SUS-2024-00013',13,'Bilal Nawaz','10.10.5.55','Bank PC Windows 10',82,'Bank employee. CCTV confirms USB usage after business hours.',3),
('SUS-2024-00014',14,'Botnet Operator','Multiple','Command and control server',68,'Botnet operator controlling machines through IRC channel.',4),
('SUS-2024-00015',15,'Identity Theft Ring','N/A','Multiple phones and laptops',78,'Organized criminal group. 5 members identified. 2 arrested.',5);
GO
PRINT 'suspects: 15 rows inserted!';
GO

-- ================================================
-- TABLE 6: custody_log (needs evidence + users)
-- evidence_id = evidence.id (1-20)
-- handled_by = users.id (1-10)
-- ================================================
INSERT INTO custody_log
(log_id, evidence_id, handled_by, action, notes)
VALUES
('CST-2024-00001',1,3,'Collected','Collected from Apache server log directory'),
('CST-2024-00002',1,3,'Analyzed','Log file analyzed for injection patterns'),
('CST-2024-00003',1,5,'Verified','Second analyst verified log integrity using hash'),
('CST-2024-00004',2,3,'Collected','Screenshot taken from attacker session replay'),
('CST-2024-00005',3,4,'Collected','Phishing email collected from victim mailbox'),
('CST-2024-00006',4,5,'Collected','Malware binary isolated in sandbox environment'),
('CST-2024-00007',4,5,'Analyzed','Malware reverse engineered — WannaCry confirmed'),
('CST-2024-00008',4,2,'Stored','Malware sample stored in secure evidence vault'),
('CST-2024-00009',5,5,'Collected','Network capture taken during active ransomware'),
('CST-2024-00010',6,6,'Collected','Database logs exported from NADRA system'),
('CST-2024-00011',7,7,'Collected','Server logs downloaded from Punjab Police server'),
('CST-2024-00012',8,3,'Collected','Dark web screenshot taken by analyst'),
('CST-2024-00013',9,4,'Collected','Firewall logs exported from MCB firewall system'),
('CST-2024-00014',10,5,'Collected','Trojan executable quarantined from infected PC'),
('CST-2024-00015',10,5,'Analyzed','Trojan analyzed in isolated sandbox environment'),
('CST-2024-00016',13,8,'Collected','Email header extracted from victim email client'),
('CST-2024-00017',15,9,'Collected','Exploit code dumped from server RAM'),
('CST-2024-00018',16,3,'Collected','CCTV footage downloaded from bank security system'),
('CST-2024-00019',17,3,'Collected','USB forensic image created using FTK Imager tool'),
('CST-2024-00020',19,5,'Collected','Bank documents scanned and digitized as evidence');
GO
PRINT 'custody_log: 20 rows inserted!';
GO

-- ================================================
-- TABLE 7: ai_analysis (needs incidents + cases)
-- ================================================
INSERT INTO ai_analysis
(analysis_id, incident_id, case_id, analysis_type,
 ai_input, ai_output, confidence, generated_by)
VALUES
('ANA-2024-00001',1,1,'threat_analysis','SQL injection attack from IP 185.220.101.45 targeting login form','THREAT: Critical SQL Injection. Block IP immediately. Use parameterized queries. Reset all database passwords.',95,3),
('ANA-2024-00002',3,2,'threat_analysis','Mass phishing emails targeting Jazz customers with fake login pages','THREAT: Organized phishing campaign. Report domain for takedown. Alert customers. Enable 2FA.',88,4),
('ANA-2024-00003',5,3,'threat_analysis','WannaCry ransomware encrypting FBR server files','THREAT: Critical ransomware. Isolate servers NOW. Do not pay ransom. Restore from backup. Patch MS17-010.',97,5),
('ANA-2024-00004',1,1,'case_summary','Case CASE-2024-00001: SQL injection on HBL Bank. 2 incidents. Evidence collected.','SUMMARY: Sophisticated attacker using Tor. SQL injection then data exfiltration. Escalate to FIA Cybercrime Wing.',92,1),
('ANA-2024-00005',8,5,'threat_analysis','DDoS attack sending 50000 requests per second to Punjab Police website','THREAT: Large DDoS botnet. Enable Cloudflare protection. Rate limit connections. Contact ISP for upstream blocking.',85,7),
('ANA-2024-00006',10,7,'threat_analysis','Brute force attack attempting 5000 logins per minute on MCB banking','THREAT: Credential stuffing attack. Implement CAPTCHA. Lock after 5 attempts. Block IP range. Enable 2FA.',91,4),
('ANA-2024-00007',12,8,'threat_analysis','Trojan malware found on 15 government computers spreading through USB','THREAT: USB-spread Trojan with keylogger. Disable USB ports. Run full scan. Change all passwords.',87,5),
('ANA-2024-00008',15,11,'threat_analysis','Spear phishing email with malicious PDF targeting minister office','THREAT: APT-level attack. State sponsored suspected. Isolate systems. Notify national cybersecurity authority.',96,8),
('ANA-2024-00009',17,12,'threat_analysis','Zero day exploit used against Apache 2.4 gaining root access','THREAT: Critical zero day. Take server offline immediately. Report to Apache team. Check all other servers.',98,9),
('ANA-2024-00010',7,4,'case_summary','CASE-2024-00004: Insider threat at NADRA. Ahmed Raza accessed restricted database.','SUMMARY: Confirmed insider threat. Strong evidence. Suspend employee. Legal action under PECA 2016.',93,6),
('ANA-2024-00011',14,10,'threat_analysis','Cryptojacking mining software XMRig on university servers','THREAT: Cryptomining malware. Remove XMRig. Patch WordPress. Monitor CPU. Scan all servers.',82,7),
('ANA-2024-00012',18,13,'threat_analysis','Bank employee copying customer data to USB drive after hours','THREAT: Insider data theft confirmed. CCTV and USB evidence strong. Suspend employee. File FIR under PECA.',94,3),
('ANA-2024-00013',3,2,'risk_score','Assess risk score for phishing group targeting Jazz customers','RISK: Score 80/100. Organized group, multi-country operation, bulletproof hosting. High repeat attack probability.',86,4),
('ANA-2024-00014',19,14,'threat_analysis','Botnet of 2000 infected machines sending spam through ISP','THREAT: Active botnet on ISP. Notify infected customers. Block C2 servers. Coordinate with international CERTs.',83,4),
('ANA-2024-00015',20,15,'threat_analysis','Identity theft ring using stolen CNICs to open fake bank accounts','THREAT: Organized financial crime. Alert all banks. Share suspects with NADRA. Coordinate with FIA.',89,5);
GO
PRINT 'ai_analysis: 15 rows inserted!';
GO

-- ================================================
-- TABLE 8: ai_recommendations (needs ai_analysis)
-- analysis_id = ai_analysis.id (1-15)
-- ================================================
INSERT INTO ai_recommendations
(rec_id, analysis_id, case_id, recommendation,
 priority, status, reviewed_by, reviewed_at)
VALUES
('REC-2024-00001',1,1,'Block IP address 185.220.101.45 at firewall immediately','Critical','Accepted',3,'2024-01-10 04:00:00'),
('REC-2024-00002',1,1,'Implement parameterized queries to prevent SQL injection','Critical','Accepted',3,'2024-01-10 04:05:00'),
('REC-2024-00003',1,1,'Reset all database user passwords immediately','High','Accepted',1,'2024-01-10 05:00:00'),
('REC-2024-00004',2,2,'Report phishing domain to registrar for immediate takedown','High','Accepted',4,'2024-01-12 09:00:00'),
('REC-2024-00005',2,2,'Send security alert to all Jazz customers about phishing','High','Pending',NULL,NULL),
('REC-2024-00006',3,3,'Isolate all infected FBR servers from network immediately','Critical','Accepted',5,'2024-01-13 03:00:00'),
('REC-2024-00007',3,3,'Restore FBR systems from last clean backup','Critical','Accepted',2,'2024-01-13 04:00:00'),
('REC-2024-00008',3,3,'Patch MS17-010 vulnerability on all Windows servers','Critical','Pending',NULL,NULL),
('REC-2024-00009',6,7,'Implement CAPTCHA on MCB internet banking login page','High','Accepted',4,'2024-01-16 05:00:00'),
('REC-2024-00010',6,7,'Enable account lockout after 5 failed login attempts','High','Accepted',4,'2024-01-16 05:30:00'),
('REC-2024-00011',8,11,'Isolate minister office systems from main network','Critical','Accepted',8,'2024-01-19 12:00:00'),
('REC-2024-00012',9,12,'Take vulnerable Apache server offline immediately','Critical','Accepted',9,'2024-01-20 01:30:00'),
('REC-2024-00013',9,12,'Report zero day vulnerability to Apache security team','High','Pending',NULL,NULL),
('REC-2024-00014',12,13,'Suspend employee Bilal Nawaz and revoke all system access','Critical','Accepted',3,'2024-01-21 20:00:00'),
('REC-2024-00015',12,13,'File FIR with FIA Cybercrime Wing under PECA 2016','High','Accepted',1,'2024-01-21 21:00:00');
GO
PRINT 'ai_recommendations: 15 rows inserted!';
GO

-- ================================================
-- TABLE 9: threat_alerts (needs incidents + cases)
-- ================================================
INSERT INTO threat_alerts
(alert_id, incident_id, case_id, alert_type,
 message, is_read, read_by)
VALUES
('ALT-2024-00001',1,1,'Critical Severity Incident','CRITICAL: SQL Injection on HBL Bank detected. Immediate action required.',1,1),
('ALT-2024-00002',5,3,'Critical Severity Incident','CRITICAL: Ransomware on FBR server. Isolate immediately!',1,2),
('ALT-2024-00003',3,2,'New Incident Logged','HIGH: Phishing campaign targeting Jazz customers. 500 emails sent.',1,1),
('ALT-2024-00004',9,6,'Data Breach Detected','CRITICAL: Telenor customer data found on dark web.',0,NULL),
('ALT-2024-00005',10,7,'Brute Force Detected','HIGH: Brute force on MCB banking. 5000 attempts in 10 minutes.',1,4),
('ALT-2024-00006',15,11,'Critical Severity Incident','CRITICAL: APT spear phishing on minister office. State sponsored.',0,NULL),
('ALT-2024-00007',17,12,'Zero Day Exploit','CRITICAL: Zero day exploit on Apache server. Root access gained.',0,NULL),
('ALT-2024-00008',7,4,'Insider Threat','HIGH: Insider threat at NADRA. Employee accessed restricted database.',1,1),
('ALT-2024-00009',12,8,'Malware Detected','HIGH: Trojan on 15 government computers. USB spread confirmed.',1,2),
('ALT-2024-00010',14,10,'Cryptomining Detected','LOW: Cryptojacking on university servers. Remove immediately.',1,1),
('ALT-2024-00011',18,13,'Insider Threat','HIGH: Bank employee copying data to USB confirmed on CCTV.',0,NULL),
('ALT-2024-00012',19,14,'Botnet Activity','MEDIUM: Botnet on ISP network. 2000 infected machines.',0,NULL),
('ALT-2024-00013',20,15,'Identity Fraud','HIGH: Identity theft ring. 50 fraudulent accounts opened.',0,NULL),
('ALT-2024-00014',16,11,'Malware Execution','CRITICAL: Backdoor malware executed in minister office.',0,NULL),
('ALT-2024-00015',25,12,'Privilege Escalation','CRITICAL: Attacker got root access after Apache exploit.',0,NULL);
GO
PRINT 'threat_alerts: 15 rows inserted!';
GO

-- ================================================
-- TABLE 10: activity_log (needs users)
-- ================================================
INSERT INTO activity_log
(log_id, user_id, action, table_name, record_id, ip_address)
VALUES
('ACT-2024-00001',1,'Created case CASE-2024-00001','cases','CASE-2024-00001','192.168.1.10'),
('ACT-2024-00002',3,'Logged incident INC-2024-00001','incidents','INC-2024-00001','192.168.1.15'),
('ACT-2024-00003',3,'Added evidence EVD-2024-00001','evidence','EVD-2024-00001','192.168.1.15'),
('ACT-2024-00004',1,'Created case CASE-2024-00002','cases','CASE-2024-00002','192.168.1.10'),
('ACT-2024-00005',4,'Logged incident INC-2024-00003','incidents','INC-2024-00003','192.168.1.20'),
('ACT-2024-00006',2,'Created case CASE-2024-00003','cases','CASE-2024-00003','192.168.1.11'),
('ACT-2024-00007',5,'Logged incident INC-2024-00005','incidents','INC-2024-00005','192.168.1.25'),
('ACT-2024-00008',5,'Added evidence EVD-2024-00004','evidence','EVD-2024-00004','192.168.1.25'),
('ACT-2024-00009',3,'Generated AI analysis ANA-2024-00001','ai_analysis','ANA-2024-00001','192.168.1.15'),
('ACT-2024-00010',1,'Accepted recommendation REC-2024-00001','ai_recommendations','REC-2024-00001','192.168.1.10'),
('ACT-2024-00011',6,'Added suspect SUS-2024-00004','suspects','SUS-2024-00004','192.168.1.30'),
('ACT-2024-00012',3,'Updated case CASE-2024-00004 to Closed','cases','CASE-2024-00004','192.168.1.15'),
('ACT-2024-00013',7,'Logged incident INC-2024-00008','incidents','INC-2024-00008','192.168.1.35'),
('ACT-2024-00014',4,'Generated AI analysis ANA-2024-00006','ai_analysis','ANA-2024-00006','192.168.1.20'),
('ACT-2024-00015',8,'Added evidence EVD-2024-00013','evidence','EVD-2024-00013','192.168.1.40'),
('ACT-2024-00016',9,'Added evidence EVD-2024-00015','evidence','EVD-2024-00015','192.168.1.45'),
('ACT-2024-00017',3,'Updated case CASE-2024-00005 to Closed','cases','CASE-2024-00005','192.168.1.15'),
('ACT-2024-00018',1,'Read alert ALT-2024-00001','threat_alerts','ALT-2024-00001','192.168.1.10'),
('ACT-2024-00019',3,'Added custody log CST-2024-00001','custody_log','CST-2024-00001','192.168.1.15'),
('ACT-2024-00020',2,'Generated report RPT-2024-00001','reports','RPT-2024-00001','192.168.1.11');
GO
PRINT 'activity_log: 20 rows inserted!';
GO

-- ================================================
-- TABLE 11: reports (needs cases + users)
-- ================================================
INSERT INTO reports
(report_id, case_id, title, content, report_type, generated_by)
VALUES
('RPT-2024-00001',1,'HBL Bank SQL Injection — Final Report','FINAL: SQL injection confirmed. Attacker from Tor node in Germany. Customer data compromised. Escalated to FIA.','Final',1),
('RPT-2024-00002',2,'Jazz Phishing — AI Summary','AI: Large phishing campaign on Jazz customers. Domain taken down. Customer alert issued. 2FA recommended.','AI Generated',4),
('RPT-2024-00003',3,'FBR Ransomware — Incident Report','INCIDENT: WannaCry ransomware on FBR. Systems isolated. Backup restoration in progress. MS17-010 patch deploying.','Manual',5),
('RPT-2024-00004',4,'NADRA Insider Threat — Final Report','FINAL: Insider Ahmed Raza confirmed. Database logs and CCTV evidence secured. FIR filed. Case closed.','Final',6),
('RPT-2024-00005',6,'Telenor Data Breach — Investigation','INVESTIGATION: Customer data breach confirmed. Dark web listing found. Source still under investigation.','Manual',3),
('RPT-2024-00006',7,'MCB Brute Force — AI Report','AI: Brute force on MCB banking. CAPTCHA and lockout implemented. IP blocked. No successful compromises.','AI Generated',4),
('RPT-2024-00007',11,'Minister Office APT — Confidential','CONFIDENTIAL: State sponsored APT confirmed. Systems isolated. National cybersecurity authority notified.','Final',8),
('RPT-2024-00008',12,'Apache Zero Day — Technical Report','TECHNICAL: Zero day on Apache 2.4 confirmed. Server offline. Vulnerability reported to Apache team.','Manual',9),
('RPT-2024-00009',13,'Meezan Bank Insider — Legal Report','LEGAL: Bilal Nawaz data theft confirmed. USB forensics secured. FIR filed under PECA 2016 Section 14.','Final',3),
('RPT-2024-00010',15,'Identity Theft Ring — Intelligence','INTELLIGENCE: 5 members identified. 2 arrested. 50 fraudulent accounts frozen. Investigation continuing.','Manual',5);
GO
PRINT 'reports: 10 rows inserted!';
GO

-- ================================================
-- TABLE 12: case_notes (needs cases + users)
-- ================================================
INSERT INTO case_notes
(note_id, case_id, content, is_private, created_by)
VALUES
('NTE-2024-00001',1,'Attacker used Tor browser — IP tracing very difficult. Need to analyze attack patterns.',0,3),
('NTE-2024-00002',1,'HBL security team cooperating fully. Provided server access within 2 hours.',0,3),
('NTE-2024-00003',2,'Phishing domain registered only 24 hours before attack — typical throwaway technique.',0,4),
('NTE-2024-00004',2,'Jazz IT team slow to respond. Escalated to their CISO directly.',1,4),
('NTE-2024-00005',3,'FBR refused to pay ransom. Good decision. Backup restoration underway.',0,5),
('NTE-2024-00006',3,'Ransomware entered through unpatched Windows Server 2016. Patch management failure.',0,5),
('NTE-2024-00007',4,'Ahmed Raza cooperative in interview. Claims financial pressure forced him.',1,6),
('NTE-2024-00008',4,'NADRA audit shows 2300 citizen records accessed without authorization.',0,6),
('NTE-2024-00009',6,'Telenor breach possibly linked to insider. Still investigating internal access logs.',1,3),
('NTE-2024-00010',7,'MCB attack from same IP range as UBL attack in December 2023.',0,4),
('NTE-2024-00011',8,'USB ports should have been disabled on all government PCs. Security policy failure.',0,5),
('NTE-2024-00012',11,'APT group signature matches Lazarus Group techniques. Possible state sponsored.',1,8),
('NTE-2024-00013',12,'Zero day exploit extremely sophisticated. Likely purchased from dark web.',0,9),
('NTE-2024-00014',13,'Bilal Nawaz had financial debts. Competitor bank may have paid for customer data.',1,3),
('NTE-2024-00015',15,'Two arrested suspects revealed ring operating for 8 months across 4 cities.',0,5);
GO
PRINT 'case_notes: 15 rows inserted!';
GO

-- ================================================
-- FINAL VERIFICATION
-- ================================================
SELECT 'users'              AS 'Table', COUNT(*) AS 'Rows' FROM users
UNION ALL
SELECT 'cases',              COUNT(*) FROM cases
UNION ALL
SELECT 'incidents',          COUNT(*) FROM incidents
UNION ALL
SELECT 'evidence',           COUNT(*) FROM evidence
UNION ALL
SELECT 'suspects',           COUNT(*) FROM suspects
UNION ALL
SELECT 'custody_log',        COUNT(*) FROM custody_log
UNION ALL
SELECT 'ai_analysis',        COUNT(*) FROM ai_analysis
UNION ALL
SELECT 'ai_recommendations', COUNT(*) FROM ai_recommendations
UNION ALL
SELECT 'threat_alerts',      COUNT(*) FROM threat_alerts
UNION ALL
SELECT 'activity_log',       COUNT(*) FROM activity_log
UNION ALL
SELECT 'reports',            COUNT(*) FROM reports
UNION ALL
SELECT 'case_notes',         COUNT(*) FROM case_notes;
GO

PRINT '================================================';
PRINT 'All 195 rows inserted successfully!';
PRINT 'CyberSOC Pro database fully populated!';
PRINT '================================================';
GO