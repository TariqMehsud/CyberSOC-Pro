-- ================================================
-- CyberSOC Pro — DDL Script
-- All 12 Tables CREATE statements
-- Milestone 4 — Database Setup
-- Student: Tariq Ahmad
-- Date: April 2026
-- ================================================

USE CyberSOC_Pro;
GO

-- TABLE 1: users
IF OBJECT_ID('dbo.users','U') IS NOT NULL DROP TABLE users;
GO
CREATE TABLE users (
    id            INT IDENTITY(1,1)   NOT NULL,
    user_id       VARCHAR(20)         NOT NULL,
    username      VARCHAR(50)         NOT NULL,
    password_hash VARCHAR(255)        NOT NULL,
    role          VARCHAR(20)         NOT NULL,
    full_name     VARCHAR(100)        NOT NULL,
    email         VARCHAR(100)        NOT NULL,
    last_login    DATETIME            NULL,
    is_active     BIT                 NOT NULL DEFAULT 1,
    created_at    DATETIME            NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_users        PRIMARY KEY (id),
    CONSTRAINT UQ_users_userid UNIQUE (user_id),
    CONSTRAINT UQ_users_uname  UNIQUE (username),
    CONSTRAINT UQ_users_email  UNIQUE (email),
    CONSTRAINT CK_users_role   CHECK  (role IN ('Admin','Analyst'))
);
CREATE INDEX IX_users_role ON users(role);
GO

-- TABLE 2: cases
IF OBJECT_ID('dbo.cases','U') IS NOT NULL DROP TABLE cases;
GO
CREATE TABLE cases (
    id           INT IDENTITY(1,1)   NOT NULL,
    case_id      VARCHAR(20)         NOT NULL,
    title        VARCHAR(200)        NOT NULL,
    case_type    VARCHAR(100)        NOT NULL,
    status       VARCHAR(50)         NOT NULL DEFAULT 'Open',
    priority     VARCHAR(20)         NOT NULL DEFAULT 'Medium',
    opened_date  DATE                NOT NULL DEFAULT GETDATE(),
    closed_date  DATE                NULL,
    assigned_to  INT                 NULL,
    created_by   INT                 NOT NULL,
    description  TEXT                NULL,
    CONSTRAINT PK_cases          PRIMARY KEY (id),
    CONSTRAINT UQ_cases_caseid   UNIQUE (case_id),
    CONSTRAINT CK_cases_status   CHECK (status   IN ('Open','Investigating','Closed')),
    CONSTRAINT CK_cases_priority CHECK (priority IN ('Low','Medium','High','Critical')),
    CONSTRAINT FK_cases_assigned FOREIGN KEY (assigned_to) REFERENCES users(id),
    CONSTRAINT FK_cases_created  FOREIGN KEY (created_by)  REFERENCES users(id)
);
CREATE INDEX IX_cases_status   ON cases(status);
CREATE INDEX IX_cases_priority ON cases(priority);
CREATE INDEX IX_cases_assigned ON cases(assigned_to);
GO

-- TABLE 3: incidents
IF OBJECT_ID('dbo.incidents','U') IS NOT NULL DROP TABLE incidents;
GO
CREATE TABLE incidents (
    id           INT IDENTITY(1,1)   NOT NULL,
    incident_id  VARCHAR(20)         NOT NULL,
    case_id      INT                 NOT NULL,
    event_type   VARCHAR(100)        NOT NULL,
    source_ip    VARCHAR(50)         NULL,
    target_ip    VARCHAR(50)         NULL,
    severity     VARCHAR(20)         NOT NULL DEFAULT 'Medium',
    status       VARCHAR(50)         NOT NULL DEFAULT 'Open',
    description  TEXT                NULL,
    reported_by  INT                 NULL,
    timestamp    DATETIME            NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_incidents          PRIMARY KEY (id),
    CONSTRAINT UQ_incidents_id       UNIQUE (incident_id),
    CONSTRAINT CK_incidents_severity CHECK (severity IN ('Critical','High','Medium','Low')),
    CONSTRAINT CK_incidents_status   CHECK (status   IN ('Open','Investigating','Resolved')),
    CONSTRAINT FK_incidents_case     FOREIGN KEY (case_id)     REFERENCES cases(id),
    CONSTRAINT FK_incidents_reported FOREIGN KEY (reported_by) REFERENCES users(id)
);
CREATE INDEX IX_incidents_caseid   ON incidents(case_id);
CREATE INDEX IX_incidents_severity ON incidents(severity);
CREATE INDEX IX_incidents_status   ON incidents(status);
GO

-- TABLE 4: evidence
IF OBJECT_ID('dbo.evidence','U') IS NOT NULL DROP TABLE evidence;
GO
CREATE TABLE evidence (
    id            INT IDENTITY(1,1)   NOT NULL,
    evidence_id   VARCHAR(20)         NOT NULL,
    case_id       INT                 NOT NULL,
    evidence_type VARCHAR(100)        NOT NULL,
    description   TEXT                NULL,
    file_hash     VARCHAR(200)        NULL,
    collected_by  INT                 NOT NULL,
    collected_at  DATETIME            NOT NULL DEFAULT GETDATE(),
    is_verified   BIT                 NOT NULL DEFAULT 0,
    CONSTRAINT PK_evidence           PRIMARY KEY (id),
    CONSTRAINT UQ_evidence_id        UNIQUE (evidence_id),
    CONSTRAINT FK_evidence_case      FOREIGN KEY (case_id)      REFERENCES cases(id),
    CONSTRAINT FK_evidence_collector FOREIGN KEY (collected_by) REFERENCES users(id)
);
CREATE INDEX IX_evidence_caseid ON evidence(case_id);
GO

-- TABLE 5: suspects
IF OBJECT_ID('dbo.suspects','U') IS NOT NULL DROP TABLE suspects;
GO
CREATE TABLE suspects (
    id          INT IDENTITY(1,1)   NOT NULL,
    suspect_id  VARCHAR(20)         NOT NULL,
    case_id     INT                 NOT NULL,
    name        VARCHAR(100)        NULL,
    ip_address  VARCHAR(50)         NULL,
    device_info VARCHAR(200)        NULL,
    risk_score  INT                 NOT NULL DEFAULT 0,
    notes       TEXT                NULL,
    added_by    INT                 NOT NULL,
    CONSTRAINT PK_suspects         PRIMARY KEY (id),
    CONSTRAINT UQ_suspects_id      UNIQUE (suspect_id),
    CONSTRAINT CK_suspects_risk    CHECK (risk_score BETWEEN 0 AND 100),
    CONSTRAINT FK_suspects_case    FOREIGN KEY (case_id)  REFERENCES cases(id),
    CONSTRAINT FK_suspects_addedby FOREIGN KEY (added_by) REFERENCES users(id)
);
CREATE INDEX IX_suspects_caseid ON suspects(case_id);
GO

-- TABLE 6: custody_log
IF OBJECT_ID('dbo.custody_log','U') IS NOT NULL DROP TABLE custody_log;
GO
CREATE TABLE custody_log (
    id          INT IDENTITY(1,1)   NOT NULL,
    log_id      VARCHAR(20)         NOT NULL,
    evidence_id INT                 NOT NULL,
    handled_by  INT                 NOT NULL,
    action      VARCHAR(100)        NOT NULL,
    timestamp   DATETIME            NOT NULL DEFAULT GETDATE(),
    notes       TEXT                NULL,
    CONSTRAINT PK_custody          PRIMARY KEY (id),
    CONSTRAINT UQ_custody_id       UNIQUE (log_id),
    CONSTRAINT CK_custody_action   CHECK (action IN ('Collected','Analyzed','Stored','Transferred','Verified')),
    CONSTRAINT FK_custody_evidence FOREIGN KEY (evidence_id) REFERENCES evidence(id),
    CONSTRAINT FK_custody_handler  FOREIGN KEY (handled_by)  REFERENCES users(id)
);
CREATE INDEX IX_custody_evidenceid ON custody_log(evidence_id);
GO

-- TABLE 7: ai_analysis
IF OBJECT_ID('dbo.ai_analysis','U') IS NOT NULL DROP TABLE ai_analysis;
GO
CREATE TABLE ai_analysis (
    id            INT IDENTITY(1,1)   NOT NULL,
    analysis_id   VARCHAR(20)         NOT NULL,
    incident_id   INT                 NULL,
    case_id       INT                 NULL,
    analysis_type VARCHAR(50)         NOT NULL,
    ai_input      TEXT                NOT NULL,
    ai_output     TEXT                NOT NULL,
    confidence    INT                 NOT NULL DEFAULT 0,
    generated_by  INT                 NOT NULL,
    generated_at  DATETIME            NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_ai_analysis          PRIMARY KEY (id),
    CONSTRAINT UQ_ai_analysis_id       UNIQUE (analysis_id),
    CONSTRAINT CK_ai_analysis_type     CHECK (analysis_type IN ('threat_analysis','case_summary','risk_score','recommendation')),
    CONSTRAINT CK_ai_confidence        CHECK (confidence BETWEEN 0 AND 100),
    CONSTRAINT FK_ai_analysis_incident FOREIGN KEY (incident_id)  REFERENCES incidents(id),
    CONSTRAINT FK_ai_analysis_case     FOREIGN KEY (case_id)      REFERENCES cases(id),
    CONSTRAINT FK_ai_analysis_user     FOREIGN KEY (generated_by) REFERENCES users(id)
);
CREATE INDEX IX_ai_analysis_caseid     ON ai_analysis(case_id);
CREATE INDEX IX_ai_analysis_incidentid ON ai_analysis(incident_id);
GO

-- TABLE 8: ai_recommendations
IF OBJECT_ID('dbo.ai_recommendations','U') IS NOT NULL DROP TABLE ai_recommendations;
GO
CREATE TABLE ai_recommendations (
    id             INT IDENTITY(1,1)   NOT NULL,
    rec_id         VARCHAR(20)         NOT NULL,
    analysis_id    INT                 NOT NULL,
    case_id        INT                 NOT NULL,
    recommendation TEXT                NOT NULL,
    priority       VARCHAR(20)         NOT NULL,
    status         VARCHAR(50)         NOT NULL DEFAULT 'Pending',
    reviewed_by    INT                 NULL,
    reviewed_at    DATETIME            NULL,
    CONSTRAINT PK_ai_rec          PRIMARY KEY (id),
    CONSTRAINT UQ_ai_rec_id       UNIQUE (rec_id),
    CONSTRAINT CK_ai_rec_priority CHECK (priority IN ('Critical','High','Medium','Low')),
    CONSTRAINT CK_ai_rec_status   CHECK (status   IN ('Pending','Accepted','Rejected')),
    CONSTRAINT FK_ai_rec_analysis FOREIGN KEY (analysis_id) REFERENCES ai_analysis(id),
    CONSTRAINT FK_ai_rec_case     FOREIGN KEY (case_id)     REFERENCES cases(id),
    CONSTRAINT FK_ai_rec_reviewer FOREIGN KEY (reviewed_by) REFERENCES users(id)
);
CREATE INDEX IX_ai_rec_caseid ON ai_recommendations(case_id);
GO

-- TABLE 9: threat_alerts
IF OBJECT_ID('dbo.threat_alerts','U') IS NOT NULL DROP TABLE threat_alerts;
GO
CREATE TABLE threat_alerts (
    id          INT IDENTITY(1,1)   NOT NULL,
    alert_id    VARCHAR(20)         NOT NULL,
    incident_id INT                 NULL,
    case_id     INT                 NULL,
    alert_type  VARCHAR(100)        NOT NULL,
    message     TEXT                NOT NULL,
    is_read     BIT                 NOT NULL DEFAULT 0,
    created_at  DATETIME            NOT NULL DEFAULT GETDATE(),
    read_by     INT                 NULL,
    CONSTRAINT PK_alerts          PRIMARY KEY (id),
    CONSTRAINT UQ_alerts_id       UNIQUE (alert_id),
    CONSTRAINT FK_alerts_incident FOREIGN KEY (incident_id) REFERENCES incidents(id),
    CONSTRAINT FK_alerts_case     FOREIGN KEY (case_id)     REFERENCES cases(id),
    CONSTRAINT FK_alerts_readby   FOREIGN KEY (read_by)     REFERENCES users(id)
);
CREATE INDEX IX_alerts_isread ON threat_alerts(is_read);
CREATE INDEX IX_alerts_caseid ON threat_alerts(case_id);
GO

-- TABLE 10: activity_log
IF OBJECT_ID('dbo.activity_log','U') IS NOT NULL DROP TABLE activity_log;
GO
CREATE TABLE activity_log (
    id         INT IDENTITY(1,1)   NOT NULL,
    log_id     VARCHAR(20)         NOT NULL,
    user_id    INT                 NOT NULL,
    action     VARCHAR(200)        NOT NULL,
    table_name VARCHAR(50)         NULL,
    record_id  VARCHAR(20)         NULL,
    ip_address VARCHAR(50)         NULL,
    timestamp  DATETIME            NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_activity      PRIMARY KEY (id),
    CONSTRAINT UQ_activity_id   UNIQUE (log_id),
    CONSTRAINT FK_activity_user FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE INDEX IX_activity_userid    ON activity_log(user_id);
CREATE INDEX IX_activity_timestamp ON activity_log(timestamp);
GO

-- TABLE 11: reports
IF OBJECT_ID('dbo.reports','U') IS NOT NULL DROP TABLE reports;
GO
CREATE TABLE reports (
    id           INT IDENTITY(1,1)   NOT NULL,
    report_id    VARCHAR(20)         NOT NULL,
    case_id      INT                 NOT NULL,
    title        VARCHAR(200)        NOT NULL,
    content      TEXT                NOT NULL,
    report_type  VARCHAR(50)         NOT NULL DEFAULT 'Manual',
    generated_by INT                 NOT NULL,
    generated_at DATETIME            NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_reports           PRIMARY KEY (id),
    CONSTRAINT UQ_reports_id        UNIQUE (report_id),
    CONSTRAINT CK_reports_type      CHECK (report_type IN ('AI Generated','Manual','Final')),
    CONSTRAINT FK_reports_case      FOREIGN KEY (case_id)      REFERENCES cases(id),
    CONSTRAINT FK_reports_generator FOREIGN KEY (generated_by) REFERENCES users(id)
);
CREATE INDEX IX_reports_caseid ON reports(case_id);
GO

-- TABLE 12: case_notes
IF OBJECT_ID('dbo.case_notes','U') IS NOT NULL DROP TABLE case_notes;
GO
CREATE TABLE case_notes (
    id         INT IDENTITY(1,1)   NOT NULL,
    note_id    VARCHAR(20)         NOT NULL,
    case_id    INT                 NOT NULL,
    content    TEXT                NOT NULL,
    is_private BIT                 NOT NULL DEFAULT 0,
    created_by INT                 NOT NULL,
    created_at DATETIME            NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_case_notes      PRIMARY KEY (id),
    CONSTRAINT UQ_case_notes_id   UNIQUE (note_id),
    CONSTRAINT FK_case_notes_case FOREIGN KEY (case_id)    REFERENCES cases(id),
    CONSTRAINT FK_case_notes_user FOREIGN KEY (created_by) REFERENCES users(id)
);
CREATE INDEX IX_case_notes_caseid ON case_notes(case_id);
GO

PRINT 'All 12 tables created successfully!';
PRINT 'CyberSOC Pro DDL Script Complete!';
GO