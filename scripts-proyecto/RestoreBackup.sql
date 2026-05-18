-- Restore DATABASEs

RESTORE DATABASE procinal
FROM DISK = 'C:\Backup\procinal_full.bak'
WITH REPLACE;
GO

RESTORE DATABASE procinal
FROM DISK = 'C:\Backup\procinal_full.bak'
WITH NORECOVERY;
GO

RESTORE DATABASE procinal
FROM DISK = 'C:\Backup\procinal_diff.bak'
WITH RECOVERY;
GO

RESTORE LOG procinal
FROM DISK = 'C:\Backup\procinal_log.trn'
WITH RECOVERY;
GO

-- Back up DATABASE
BACKUP DATABASE procinal
TO DISK = 'C:\Backup\procinal_full.bak'
WITH FORMAT,
NAME = 'Backup Completo Procinal';
GO

BACKUP DATABASE procinal
TO DISK = 'C:\Backup\procinal_diff.bak'
WITH DIFFERENTIAL,
NAME = 'Backup Diferencial Procinal';
GO

BACKUP LOG procinal
TO DISK = 'C:\Backup\procinal_log.trn'
WITH NAME = 'Backup Log Procinal';
GO
