/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

MERGE INTO dbo.StatusTypes AS Target 
USING (
	Select 1, N'Not Assigned yet' UNION ALL
	Select 2, N'Pending' UNION ALL
	Select 3, N'Accepted' UNION ALL
	SELECT 4, N'Rejected' UNION ALL
	SELECT 5, N'N/A'  UNION ALL
	SELECT 6, N'New Application'
) 
AS Source ([StatusTypeID], [StatusType]) 
ON Target.StatusTypeID = Source.StatusTypeID
WHEN MATCHED THEN 
UPDATE SET 
	StatusType = Source.StatusType

WHEN NOT MATCHED BY TARGET THEN 
INSERT ([StatusTypeID], [StatusType]) 
VALUES ([StatusTypeID], [StatusType]);
--WHEN NOT MATCHED BY SOURCE THEN 
--DELETE;
GO

IF NOT Exists(Select * from dbo.Users Where UserID = 1)
BEGIN
	Insert into dbo.users(UserID,Login,Password,Email)
	Select 1,'bilal','123','bilal@abc.com'
END
