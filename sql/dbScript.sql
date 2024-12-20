USE [master]
GO
/****** Object:  Database [TrafficViolations]    Script Date: 08.05.2024 14:28:46 ******/
CREATE DATABASE [TrafficViolations]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TrafficViolations', FILENAME = N'D:\SQL\Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\TrafficViolations.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TrafficViolations_log', FILENAME = N'D:\SQL\Server\MSSQL16.SQLEXPRESS\MSSQL\DATA\TrafficViolations_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [TrafficViolations] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TrafficViolations].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TrafficViolations] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TrafficViolations] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TrafficViolations] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TrafficViolations] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TrafficViolations] SET ARITHABORT OFF 
GO
ALTER DATABASE [TrafficViolations] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TrafficViolations] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TrafficViolations] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TrafficViolations] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TrafficViolations] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TrafficViolations] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TrafficViolations] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TrafficViolations] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TrafficViolations] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TrafficViolations] SET  DISABLE_BROKER 
GO
ALTER DATABASE [TrafficViolations] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TrafficViolations] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TrafficViolations] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TrafficViolations] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TrafficViolations] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TrafficViolations] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TrafficViolations] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TrafficViolations] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [TrafficViolations] SET  MULTI_USER 
GO
ALTER DATABASE [TrafficViolations] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TrafficViolations] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TrafficViolations] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TrafficViolations] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TrafficViolations] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [TrafficViolations] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [TrafficViolations] SET QUERY_STORE = ON
GO
ALTER DATABASE [TrafficViolations] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [TrafficViolations]
GO
/****** Object:  UserDefinedFunction [dbo].[GetDefaultDriverLicense]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[GetDefaultDriverLicense]
(
    @driver_id int
)
RETURNS nchar(10)
AS
begin
    DECLARE @license_number VARCHAR(50);

    SELECT TOP 1 @license_number = License_Number
    FROM Driver_Licenses
    WHERE Driver_ID = @driver_id
    ORDER BY License_Number

    RETURN @license_number
end
GO
/****** Object:  Table [dbo].[Drivers]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Drivers](
	[Driver_ID] [int] IDENTITY(1,1) NOT NULL,
	[First_Name] [varchar](50) NOT NULL,
	[Last_Name] [varchar](50) NOT NULL,
	[Middle_Name] [varchar](50) NOT NULL,
	[Birthdate] [date] NOT NULL,
	[Phone] [nchar](12) NOT NULL,
	[Address] [varchar](255) NOT NULL,
 CONSTRAINT [PK__Drivers__F4664ED9F2007998] PRIMARY KEY CLUSTERED 
(
	[Driver_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Driver_Licenses]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver_Licenses](
	[License_Number] [nchar](10) NOT NULL,
	[Driver_ID] [int] NOT NULL,
	[Category_ID] [nchar](3) NOT NULL,
	[Issue_Date] [date] NOT NULL,
	[Expiry_Date] [date] NOT NULL,
 CONSTRAINT [PK_Driver_Licenses] PRIMARY KEY CLUSTERED 
(
	[License_Number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetLicensesByDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[GetLicensesByDriver]
(
    @deiver_id int
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
           d.Driver_ID,
		   (d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.') as DriverFullName,
           dl.License_Number,
		   dl.Issue_Date,
		   dl.Expiry_Date
    FROM Drivers d
		 JOIN Driver_Licenses dl ON d.Driver_ID = dl.Driver_ID
    WHERE d.Driver_ID = @deiver_id
);
GO
/****** Object:  Table [dbo].[Vehicles]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vehicles](
	[Vehicle_ID] [int] IDENTITY(1,1) NOT NULL,
	[Driver_ID] [int] NOT NULL,
	[Series] [varchar](3) NOT NULL,
	[Registration_Number] [int] NOT NULL,
	[Region_Code] [int] NOT NULL,
	[Brand] [varchar](100) NULL,
	[Model] [varchar](100) NULL,
	[Year] [int] NULL,
 CONSTRAINT [PK__Vehicles__759B7F5B174B89B8] PRIMARY KEY CLUSTERED 
(
	[Vehicle_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  UserDefinedFunction [dbo].[GetVehiclesByDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[GetVehiclesByDriver]
(
    @deiver_id int
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
           d.Driver_ID,
		   (d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.') as DriverFullName,
           v.Vehicle_ID,
		   CONCAT(v.Series, ' ', CAST(v.Registration_Number AS VARCHAR(10)), ' ', CAST(v.Region_Code AS VARCHAR(3))) AS Vehicle_Info,
		   v.Brand,
		   v.Model,
		   v.Year
    FROM Drivers d
		 JOIN Vehicles v ON v.Vehicle_ID = v.Vehicle_ID
    WHERE d.Driver_ID = @deiver_id
);
GO
/****** Object:  Table [dbo].[Violations]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Violations](
	[Violation_ID] [int] IDENTITY(1,1) NOT NULL,
	[Driver_ID] [int] NOT NULL,
	[Vehicle_ID] [int] NOT NULL,
	[Violation_Type_ID] [int] NOT NULL,
	[Date_Time] [datetime] NOT NULL,
	[Place] [varchar](255) NOT NULL,
	[Fine_Amount] [decimal](10, 2) NOT NULL,
	[Payment_Status_ID] [int] NOT NULL,
 CONSTRAINT [PK__Violatio__DDDF35B914F639B7] PRIMARY KEY CLUSTERED 
(
	[Violation_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Payment_Status]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Payment_Status](
	[Payment_Status_ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Payment_Status] PRIMARY KEY CLUSTERED 
(
	[Payment_Status_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Violation_Types]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Violation_Types](
	[Violation_Type_ID] [int] IDENTITY(1,1) NOT NULL,
	[Violation_Name] [varchar](100) NOT NULL,
	[Violation_Description] [varchar](255) NULL,
 CONSTRAINT [PK__Violatio__C7FF4C7009D30258] PRIMARY KEY CLUSTERED 
(
	[Violation_Type_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[DetailedViolationsInfo]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DetailedViolationsInfo]
AS

SELECT v.Violation_ID,
       v.Date_time,
       v.Place,
       v.Fine_Amount,
       ps.Name AS Payment_Status,
       CONCAT(d.Last_Name, ' ' + left(d.First_Name, 1), '. ', left(d.Middle_Name, 1),'.') as DriverFullName,
	   [dbo].[GetDefaultDriverLicense](d.Driver_ID) as License,
       CONCAT(vh.Series, ' ', CAST(vh.Registration_Number AS VARCHAR(10)), ' ', CAST(vh.Region_Code AS VARCHAR(10))) AS VehicleInfo,
       vt.Violation_Name as ViolationTypeName,
       vt.Violation_Description as ViolationTypeDescription
FROM Violations v
JOIN Payment_Status ps ON v.Payment_Status_ID = ps.Payment_Status_ID
JOIN Drivers d ON v.Driver_ID = d.Driver_ID
JOIN Vehicles vh ON v.Vehicle_ID = vh.Vehicle_ID
JOIN Violation_Types vt ON v.Violation_Type_ID = vt.Violation_Type_ID;
GO
/****** Object:  View [dbo].[ViolationStatistics]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[ViolationStatistics] AS
SELECT vt.Violation_Name, COUNT(*) AS Total_Violations
FROM Violations v
JOIN Violation_Types vt ON v.Violation_Type_ID = vt.Violation_Type_ID
GROUP BY vt.Violation_Name;
GO
/****** Object:  View [dbo].[DriverViolationStatistics]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DriverViolationStatistics] AS
SELECT (d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.') as DriverFullName, COUNT(v.Violation_ID) AS Total_Violations
FROM Drivers d
LEFT JOIN Violations v ON d.Driver_ID = v.Driver_ID
GROUP BY d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.';
GO
/****** Object:  View [dbo].[DriverViolationTypeStatistics]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[DriverViolationTypeStatistics] AS
SELECT (d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.') as DriverFullName, vt.Violation_Name, COUNT(v.Violation_ID) AS Total_Violations
FROM Drivers d
LEFT JOIN Violations v ON d.Driver_ID = v.Driver_ID
LEFT JOIN Violation_Types vt ON v.Violation_Type_ID = vt.Violation_Type_ID
GROUP BY d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.', vt.Violation_Name;
GO
/****** Object:  UserDefinedFunction [dbo].[GetViolationsByType]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetViolationsByType]
(
    @violation_id int
)
RETURNS TABLE
AS
RETURN
(
    SELECT v.Violation_ID,
           vt.Violation_Name,
           v.Driver_ID,
		   (d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.') as DriverFullName,
           v.Vehicle_ID,
		   CONCAT(vh.Series, ' ', CAST(vh.Registration_Number AS VARCHAR(10)), ' ', CAST(vh.Region_Code AS VARCHAR(3))) AS Vehicle_Info,
           v.Date_Time,
           v.Place,
           v.Fine_Amount,
           v.Payment_Status_ID
    FROM Violation_Types vt
    JOIN Violations v ON vt.Violation_Type_ID = v.Violation_Type_ID
	JOIN Drivers d ON v.Driver_ID = d.Driver_ID
	JOIN Vehicles vh ON v.Vehicle_ID = vh.Vehicle_ID
    WHERE vt.Violation_Type_ID = @violation_id
);
GO
/****** Object:  UserDefinedFunction [dbo].[GetViolationsByDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[GetViolationsByDriver]
(
    @deiver_id int
)
RETURNS TABLE
AS
RETURN
(
    SELECT v.Violation_ID,
           vt.Violation_Name,
           v.Driver_ID,
		   (d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.') as DriverFullName,
           v.Vehicle_ID,
		   CONCAT(vh.Series, ' ', CAST(vh.Registration_Number AS VARCHAR(10)), ' ', CAST(vh.Region_Code AS VARCHAR(3))) AS Vehicle_Info,
           v.Date_Time,
           v.Place,
           v.Fine_Amount,
           v.Payment_Status_ID
    FROM Violation_Types vt
    JOIN Violations v ON vt.Violation_Type_ID = v.Violation_Type_ID
	JOIN Drivers d ON v.Driver_ID = d.Driver_ID
	JOIN Vehicles vh ON v.Vehicle_ID = vh.Vehicle_ID
    WHERE d.Driver_ID = @deiver_id
);
GO
/****** Object:  UserDefinedFunction [dbo].[GetViolationsByVehicle]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[GetViolationsByVehicle]
(
    @vehicle_id int
)
RETURNS TABLE
AS
RETURN
(
    SELECT v.Violation_ID,
           vt.Violation_Name,
           v.Driver_ID,
		   (d.Last_Name + ' ' + left(d.First_Name, 1) + '. ' + left(d.Middle_Name, 1) + '.') as DriverFullName,
           v.Vehicle_ID,
		   CONCAT(vh.Series, ' ', CAST(vh.Registration_Number AS VARCHAR(10)), ' ', CAST(vh.Region_Code AS VARCHAR(3))) AS Vehicle_Info,
           v.Date_Time,
           v.Place,
           v.Fine_Amount,
           v.Payment_Status_ID
    FROM Violation_Types vt
    JOIN Violations v ON vt.Violation_Type_ID = v.Violation_Type_ID
	JOIN Drivers d ON v.Driver_ID = d.Driver_ID
	JOIN Vehicles vh ON v.Vehicle_ID = vh.Vehicle_ID
    WHERE vh.Vehicle_ID = @vehicle_id
);
GO
/****** Object:  Table [dbo].[Driver_License_Category]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Driver_License_Category](
	[Driver_License_Caetgory_ID] [nchar](3) NOT NULL,
	[Description] [varchar](max) NOT NULL,
 CONSTRAINT [PK_Driver_License_Category] PRIMARY KEY CLUSTERED 
(
	[Driver_License_Caetgory_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Regions]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Regions](
	[Region_Code] [int] NOT NULL,
	[Region_Name] [varchar](100) NOT NULL,
	[Region_Description] [varchar](255) NULL,
 CONSTRAINT [PK__Regions__63C1AD9C56E5E988] PRIMARY KEY CLUSTERED 
(
	[Region_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
INSERT [dbo].[Driver_License_Category] ([Driver_License_Caetgory_ID], [Description]) VALUES (N'A  ', N'Мотоциклы')
INSERT [dbo].[Driver_License_Category] ([Driver_License_Caetgory_ID], [Description]) VALUES (N'B  ', N'Легковые автомобили и легкие коммерческие автомобили (до 3,5 тонн)')
INSERT [dbo].[Driver_License_Category] ([Driver_License_Caetgory_ID], [Description]) VALUES (N'C  ', N'Грузовые автомобили (свыше 3,5 тонн)')
INSERT [dbo].[Driver_License_Category] ([Driver_License_Caetgory_ID], [Description]) VALUES (N'D  ', N'Автобусы')
INSERT [dbo].[Driver_License_Category] ([Driver_License_Caetgory_ID], [Description]) VALUES (N'E  ', N'Тягачи и составы из тягача и прицепа')
INSERT [dbo].[Driver_License_Category] ([Driver_License_Caetgory_ID], [Description]) VALUES (N'M  ', N'Мопеды')
INSERT [dbo].[Driver_License_Category] ([Driver_License_Caetgory_ID], [Description]) VALUES (N'Tb ', N'Трамваи и троллейбусы')
GO
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'0123456789', 10, N'B  ', CAST(N'2019-10-05' AS Date), CAST(N'2024-10-04' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'0987123456', 11, N'A  ', CAST(N'2023-01-01' AS Date), CAST(N'2028-01-01' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'1234567890', 1, N'B  ', CAST(N'2020-01-15' AS Date), CAST(N'2025-01-14' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'2345678901', 2, N'B  ', CAST(N'2019-05-20' AS Date), CAST(N'2024-05-19' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'3453786712', 11, N'E  ', CAST(N'2020-05-25' AS Date), CAST(N'2025-05-25' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'3456789012', 3, N'B  ', CAST(N'2021-07-08' AS Date), CAST(N'2026-07-07' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'4567890123', 4, N'B  ', CAST(N'2018-03-03' AS Date), CAST(N'2023-03-02' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'5678901234', 5, N'B  ', CAST(N'2022-11-12' AS Date), CAST(N'2027-11-11' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'6789012345', 6, N'B  ', CAST(N'2023-09-30' AS Date), CAST(N'2028-09-29' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'7890123456', 7, N'B  ', CAST(N'2017-04-25' AS Date), CAST(N'2022-04-24' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'8901234567', 8, N'B  ', CAST(N'2016-08-15' AS Date), CAST(N'2021-08-14' AS Date))
INSERT [dbo].[Driver_Licenses] ([License_Number], [Driver_ID], [Category_ID], [Issue_Date], [Expiry_Date]) VALUES (N'9012345678', 9, N'C  ', CAST(N'2020-12-01' AS Date), CAST(N'2025-11-30' AS Date))
GO
SET IDENTITY_INSERT [dbo].[Drivers] ON 

INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (1, N'Иван', N'Иванов', N'Иванович', CAST(N'1990-05-15' AS Date), N'+79123456789', N'ул. Ленина, д. 1, кв. 5')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (2, N'Петр', N'Петров', N'Петрович', CAST(N'1985-10-20' AS Date), N'+79876543210', N'ул. Пушкина, д. 10, кв. 15')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (3, N'Елена', N'Сидорова', N'Александровна', CAST(N'2000-03-08' AS Date), N'+79551234567', N'пр. Гагарина, д. 5, кв. 25')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (4, N'Анна', N'Смирнова', N'Игоревна', CAST(N'1978-12-03' AS Date), N'+79798765436', N'ул. Кирова, д. 7, кв. 12')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (5, N'Сергей', N'Козлов', N'Дмитриевич', CAST(N'1995-09-25' AS Date), N'+79993332211', N'ул. Советская, д. 3, кв. 8')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (6, N'Мария', N'Николаева', N'Павловна', CAST(N'1982-07-17' AS Date), N'+79112223344', N'пр. Ленинградский, д. 20, кв. 18')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (7, N'Александр', N'Кузнецов', N'Иванович', CAST(N'1993-04-29' AS Date), N'+79556667778', N'ул. Горького, д. 12, кв. 30')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (8, N'Ольга', N'Семенова', N'Андреевна', CAST(N'1989-06-12' AS Date), N'+79889990001', N'ул. Фрунзе, д. 25, кв. 6')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (9, N'Дмитрий', N'Зайцев', N'Алексеевич', CAST(N'1975-11-07' AS Date), N'+79122334455', N'пр. Победы, д. 8, кв. 22')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (10, N'Евгения', N'Морозова', N'Сергеевна', CAST(N'1987-02-18' AS Date), N'+79344556677', N'ул. Красноармейская, д. 15, кв. 4')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (11, N'sdfdsf', N'hfh', N'0908', CAST(N'2000-01-01' AS Date), N'+79864523981', N'sdfsdf')
INSERT [dbo].[Drivers] ([Driver_ID], [First_Name], [Last_Name], [Middle_Name], [Birthdate], [Phone], [Address]) VALUES (13, N'тест', N'тест', N'535354', CAST(N'1998-03-09' AS Date), N'+79675407623', N'тест')
SET IDENTITY_INSERT [dbo].[Drivers] OFF
GO
SET IDENTITY_INSERT [dbo].[Payment_Status] ON 

INSERT [dbo].[Payment_Status] ([Payment_Status_ID], [Name]) VALUES (1, N'Оплачено')
INSERT [dbo].[Payment_Status] ([Payment_Status_ID], [Name]) VALUES (2, N'Не оплачено')
SET IDENTITY_INSERT [dbo].[Payment_Status] OFF
GO
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (1, N'Республика Адыгея', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (2, N'Республика Башкортостан', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (3, N'Республика Бурятия', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (4, N'Республика Алтай', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (5, N'Республика Дагестан', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (6, N'Республика Ингушетия', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (7, N'Кабардино-Балкарская Республика', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (8, N'Республика Калмыкия', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (9, N'Карачаево-Черкесская Республика', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (10, N'Республика Карелия', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (11, N'Республика Коми', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (12, N'Республика Марий Эл', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (13, N'Республика Мордовия', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (14, N'Республика Саха (Якутия)', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (15, N'Республика Северная Осетия-Алания', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (16, N'Республика Татарстан', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (17, N'Республика Тыва', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (18, N'Удмуртская Республика', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (19, N'Республика Хакасия', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (20, N'Чеченская Республика', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (21, N'Чувашская Республика', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (22, N'Алтайский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (23, N'Краснодарский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (24, N'Красноярский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (25, N'Приморский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (26, N'Ставропольский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (27, N'Хабаровский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (28, N'Амурская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (29, N'Архангельская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (30, N'Астраханская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (31, N'Белгородская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (32, N'Брянская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (33, N'Владимирская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (34, N'Волгоградская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (35, N'Вологодская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (36, N'Воронежская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (37, N'Ивановская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (38, N'Иркутская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (39, N'Калининградская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (40, N'Калужская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (41, N'Камчатский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (42, N'Кемеровская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (43, N'Кировская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (44, N'Костромская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (45, N'Курганская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (46, N'Курская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (47, N'Ленинградская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (48, N'Липецкая область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (49, N'Магаданская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (50, N'Московская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (51, N'Мурманская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (52, N'Нижегородская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (53, N'Новгородская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (54, N'Новосибирская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (55, N'Омская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (56, N'Оренбургская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (57, N'Орловская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (58, N'Пензенская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (59, N'Пермский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (60, N'Псковская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (61, N'Ростовская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (62, N'Рязанская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (63, N'Самарская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (64, N'Саратовская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (65, N'Сахалинская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (66, N'Свердловская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (67, N'Смоленская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (68, N'Тамбовская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (69, N'Тверская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (70, N'Томская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (71, N'Тульская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (72, N'Тюменская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (73, N'Ульяновская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (74, N'Челябинская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (75, N'Забайкальский край', N'Край в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (76, N'Ярославская область', N'Область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (77, N'город Москва', N'Город федерального значения')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (78, N'город Санкт-Петербург', N'Город федерального значения')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (79, N'Еврейская автономная область', N'Автономная область в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (80, N'Чукотский автономный округ', N'Автономный округ в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (81, N'Ненецкий автономный округ', N'Автономный округ в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (82, N'Ханты-Мансийский автономный округ — Югра', N'Автономный округ в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (83, N'Ямало-Ненецкий автономный округ', N'Автономный округ в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (84, N'Республика Крым', N'Республика в составе Российской Федерации')
INSERT [dbo].[Regions] ([Region_Code], [Region_Name], [Region_Description]) VALUES (85, N'Севастополь', N'Город федерального значения')
GO
SET IDENTITY_INSERT [dbo].[Vehicles] ON 

INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (1, 1, N'АВС', 123, 77, N'Toyota', N'Camry', 2018)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (2, 2, N'КТЕ', 456, 50, N'Hyundai', N'Solaris', 2015)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (3, 3, N'ЕКМ', 789, 33, N'Volkswagen', N'Polo', 2020)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (4, 4, N'МНО', 321, 45, N'Ford', N'Focus', 2017)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (5, 5, N'МНР', 654, 66, N'Kia', N'Rio', 2016)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (6, 6, N'АРС', 987, 22, N'BMW', N'X5', 2019)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (7, 7, N'ТВМ', 159, 55, N'Mercedes-Benz', N'E-Class', 2014)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (8, 8, N'ХРЕ', 753, 11, N'Audi', N'A4', 2013)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (9, 9, N'ВОА', 246, 44, N'Nissan', N'Qashqai', 2021)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (10, 10, N'ЕМН', 852, 81, N'Honda', N'Civic', 2018)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (11, 1, N'СКО', 468, 77, N'Toyota', N'Rav4', 2016)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (12, 2, N'МЕХ', 789, 50, N'Hyundai', N'Creta', 2017)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (13, 3, N'ОМА', 357, 33, N'Volkswagen', N'Tiguan', 2019)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (14, 4, N'ЕРХ', 246, 45, N'Ford', N'Escape', 2015)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (15, 5, N'РСХ', 753, 66, N'Kia', N'Sportage', 2018)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (16, 6, N'НОВ', 951, 22, N'BMW', N'3 Series', 2014)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (17, 7, N'ОРВ', 258, 55, N'Mercedes-Benz', N'GLC', 2017)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (18, 8, N'СХО', 147, 11, N'Audi', N'Q5', 2016)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (19, 9, N'НЕА', 369, 44, N'Nissan', N'X-Trail', 2020)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (20, 10, N'ХРМ', 852, 83, N'Honda', N'HR-V', 2019)
INSERT [dbo].[Vehicles] ([Vehicle_ID], [Driver_ID], [Series], [Registration_Number], [Region_Code], [Brand], [Model], [Year]) VALUES (21, 11, N'АКХ', 325, 59, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Vehicles] OFF
GO
SET IDENTITY_INSERT [dbo].[Violation_Types] ON 

INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (1, N'Превышение скорости', N'Превышение установленного ограничения скорости.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (2, N'Нарушение ПДД на перекрестке', N'Проезд на запрещающий сигнал светофора на перекрестке.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (3, N'Неправильная парковка', N'Парковка на тротуаре или на месте для инвалидов.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (4, N'Проезд на красный свет', N'Проезд на запрещающий сигнал светофора.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (5, N'Нарушение правил обгона', N'Выезд на встречную полосу для обгона в условиях запрещенных маневров.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (6, N'Использование телефона за рулем', N'Пользование мобильным телефоном без использования устройства громкой связи.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (7, N'Несоблюдение дистанции', N'Следование с недостаточным расстоянием до впереди идущего транспортного средства.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (8, N'Неправильный поворот', N'Поворот без включения поворотников или нарушение правил совершения поворота.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (9, N'Езда в состоянии алкогольного опьянения', N'Управление транспортным средством в состоянии алкогольного опьянения.')
INSERT [dbo].[Violation_Types] ([Violation_Type_ID], [Violation_Name], [Violation_Description]) VALUES (10, N'Проезд на пешеходном переходе', N'Проезд на пешеходном переходе в момент, когда пешеходы имеют преимущество.')
SET IDENTITY_INSERT [dbo].[Violation_Types] OFF
GO
SET IDENTITY_INSERT [dbo].[Violations] ON 

INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (1, 1, 1, 1, CAST(N'2024-01-10T08:30:00.000' AS DateTime), N'ул. Ленина, перекресток с ул. Пушкина', CAST(5000.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (2, 2, 2, 3, CAST(N'2024-02-15T13:45:00.000' AS DateTime), N'ул. Пушкина, дом 20', CAST(3000.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (3, 3, 3, 5, CAST(N'2024-03-20T11:15:00.000' AS DateTime), N'пр. Гагарина, перекресток с ул. Лермонтова', CAST(7000.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (4, 4, 4, 7, CAST(N'2024-04-25T17:30:00.000' AS DateTime), N'ул. Кирова, дом 7', CAST(4000.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (5, 5, 5, 9, CAST(N'2024-05-30T09:00:00.000' AS DateTime), N'ул. Советская, дом 3', CAST(6000.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (6, 6, 6, 2, CAST(N'2024-06-05T14:20:00.000' AS DateTime), N'пр. Ленинградский, перекресток с ул. Пушкина', CAST(4500.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (7, 7, 7, 4, CAST(N'2024-07-10T10:10:00.000' AS DateTime), N'ул. Горького, дом 12', CAST(5500.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (8, 8, 8, 6, CAST(N'2024-08-15T12:00:00.000' AS DateTime), N'ул. Фрунзе, дом 25', CAST(3500.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (9, 9, 9, 8, CAST(N'2024-09-20T16:40:00.000' AS DateTime), N'пр. Победы, перекресток с ул. Гагарина', CAST(4800.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (10, 10, 10, 10, CAST(N'2024-10-25T08:55:00.000' AS DateTime), N'ул. Красноармейская, дом 15', CAST(5200.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (13, 1, 1, 7, CAST(N'2024-04-20T09:30:00.000' AS DateTime), N'Улица Ленина, дом 10', CAST(5000.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (14, 4, 14, 3, CAST(N'2024-04-21T14:45:00.000' AS DateTime), N'Проспект Победы, дом 25', CAST(3000.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (15, 3, 3, 2, CAST(N'2024-04-22T18:20:00.000' AS DateTime), N'Площадь Свободы, дом 5', CAST(4000.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (16, 2, 2, 4, CAST(N'2024-04-23T11:10:00.000' AS DateTime), N'Улица Гагарина, дом 15', CAST(2500.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (17, 5, 5, 5, CAST(N'2024-04-24T16:55:00.000' AS DateTime), N'Проспект Ленина, дом 30', CAST(3500.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (18, 6, 6, 6, CAST(N'2024-04-25T10:20:00.000' AS DateTime), N'Улица Пушкина, дом 20', CAST(4500.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (19, 6, 16, 7, CAST(N'2024-04-26T13:40:00.000' AS DateTime), N'Площадь Революции, дом 12', CAST(2800.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (20, 6, 6, 8, CAST(N'2024-04-27T17:15:00.000' AS DateTime), N'Проспект Гагарина, дом 8', CAST(3200.00 AS Decimal(10, 2)), 2)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (21, 6, 16, 8, CAST(N'2024-04-28T12:05:00.000' AS DateTime), N'Улица Кирова, дом 18', CAST(3700.00 AS Decimal(10, 2)), 1)
INSERT [dbo].[Violations] ([Violation_ID], [Driver_ID], [Vehicle_ID], [Violation_Type_ID], [Date_Time], [Place], [Fine_Amount], [Payment_Status_ID]) VALUES (22, 10, 10, 2, CAST(N'2024-04-29T15:30:00.000' AS DateTime), N'Площадь Ленина, дом 22', CAST(4200.00 AS Decimal(10, 2)), 2)
SET IDENTITY_INSERT [dbo].[Violations] OFF
GO
ALTER TABLE [dbo].[Driver_Licenses]  WITH CHECK ADD  CONSTRAINT [FK__Driver_Li__Owner__45F365D3] FOREIGN KEY([Driver_ID])
REFERENCES [dbo].[Drivers] ([Driver_ID])
GO
ALTER TABLE [dbo].[Driver_Licenses] CHECK CONSTRAINT [FK__Driver_Li__Owner__45F365D3]
GO
ALTER TABLE [dbo].[Driver_Licenses]  WITH CHECK ADD  CONSTRAINT [FK_Driver_Licenses_Driver_License_Category] FOREIGN KEY([Category_ID])
REFERENCES [dbo].[Driver_License_Category] ([Driver_License_Caetgory_ID])
GO
ALTER TABLE [dbo].[Driver_Licenses] CHECK CONSTRAINT [FK_Driver_Licenses_Driver_License_Category]
GO
ALTER TABLE [dbo].[Driver_Licenses]  WITH CHECK ADD  CONSTRAINT [FK_DriverLicense_Driver] FOREIGN KEY([Driver_ID])
REFERENCES [dbo].[Drivers] ([Driver_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Driver_Licenses] CHECK CONSTRAINT [FK_DriverLicense_Driver]
GO
ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD  CONSTRAINT [FK__Vehicles__Owner___3B75D760] FOREIGN KEY([Driver_ID])
REFERENCES [dbo].[Drivers] ([Driver_ID])
GO
ALTER TABLE [dbo].[Vehicles] CHECK CONSTRAINT [FK__Vehicles__Owner___3B75D760]
GO
ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD  CONSTRAINT [FK__Vehicles__Region__3C69FB99] FOREIGN KEY([Region_Code])
REFERENCES [dbo].[Regions] ([Region_Code])
GO
ALTER TABLE [dbo].[Vehicles] CHECK CONSTRAINT [FK__Vehicles__Region__3C69FB99]
GO
ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD  CONSTRAINT [FK_Driver_Vehicle] FOREIGN KEY([Driver_ID])
REFERENCES [dbo].[Drivers] ([Driver_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Vehicles] CHECK CONSTRAINT [FK_Driver_Vehicle]
GO
ALTER TABLE [dbo].[Violations]  WITH CHECK ADD  CONSTRAINT [FK__Violation__Drive__412EB0B6] FOREIGN KEY([Driver_ID])
REFERENCES [dbo].[Drivers] ([Driver_ID])
GO
ALTER TABLE [dbo].[Violations] CHECK CONSTRAINT [FK__Violation__Drive__412EB0B6]
GO
ALTER TABLE [dbo].[Violations]  WITH CHECK ADD  CONSTRAINT [FK__Violation__Viola__4316F928] FOREIGN KEY([Violation_Type_ID])
REFERENCES [dbo].[Violation_Types] ([Violation_Type_ID])
GO
ALTER TABLE [dbo].[Violations] CHECK CONSTRAINT [FK__Violation__Viola__4316F928]
GO
ALTER TABLE [dbo].[Violations]  WITH CHECK ADD  CONSTRAINT [FK_Violations_Driver] FOREIGN KEY([Driver_ID])
REFERENCES [dbo].[Drivers] ([Driver_ID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Violations] CHECK CONSTRAINT [FK_Violations_Driver]
GO
ALTER TABLE [dbo].[Violations]  WITH CHECK ADD  CONSTRAINT [FK_Violations_Payment_Status] FOREIGN KEY([Payment_Status_ID])
REFERENCES [dbo].[Payment_Status] ([Payment_Status_ID])
GO
ALTER TABLE [dbo].[Violations] CHECK CONSTRAINT [FK_Violations_Payment_Status]
GO
ALTER TABLE [dbo].[Violations]  WITH CHECK ADD  CONSTRAINT [FK_Violations_Vehicles] FOREIGN KEY([Vehicle_ID])
REFERENCES [dbo].[Vehicles] ([Vehicle_ID])
GO
ALTER TABLE [dbo].[Violations] CHECK CONSTRAINT [FK_Violations_Vehicles]
GO
ALTER TABLE [dbo].[Driver_Licenses]  WITH CHECK ADD  CONSTRAINT [CHK_Dates] CHECK  ((datediff(year,[Issue_Date],[Expiry_Date])>(0)))
GO
ALTER TABLE [dbo].[Driver_Licenses] CHECK CONSTRAINT [CHK_Dates]
GO
ALTER TABLE [dbo].[Driver_Licenses]  WITH CHECK ADD  CONSTRAINT [CHK_License_Number] CHECK  ((len([License_Number])=(10) AND [License_Number] like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Driver_Licenses] CHECK CONSTRAINT [CHK_License_Number]
GO
ALTER TABLE [dbo].[Drivers]  WITH CHECK ADD  CONSTRAINT [CHK_Birthdate] CHECK  ((datediff(year,[Birthdate],getdate())>=(18)))
GO
ALTER TABLE [dbo].[Drivers] CHECK CONSTRAINT [CHK_Birthdate]
GO
ALTER TABLE [dbo].[Drivers]  WITH CHECK ADD  CONSTRAINT [CHK_Phone] CHECK  ((len([Phone])=(12) AND [Phone] like '+79[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Drivers] CHECK CONSTRAINT [CHK_Phone]
GO
ALTER TABLE [dbo].[Regions]  WITH CHECK ADD  CONSTRAINT [CHK_Region_Code] CHECK  (([Region_Code]>=(1) AND [Region_Code]<=(89)))
GO
ALTER TABLE [dbo].[Regions] CHECK CONSTRAINT [CHK_Region_Code]
GO
ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD  CONSTRAINT [CHK_Number] CHECK  (([Series] like '[АВЕКМНОРСТХ][АВЕКМНОРСТХ][АВЕКМНОРСТХ]' AND [Registration_Number] like '[0-9][0-9][0-9]'))
GO
ALTER TABLE [dbo].[Vehicles] CHECK CONSTRAINT [CHK_Number]
GO
ALTER TABLE [dbo].[Vehicles]  WITH CHECK ADD  CONSTRAINT [CHK_Year] CHECK  (([Year]>=(1885) AND [Year]<=datepart(year,getdate())))
GO
ALTER TABLE [dbo].[Vehicles] CHECK CONSTRAINT [CHK_Year]
GO
ALTER TABLE [dbo].[Violations]  WITH CHECK ADD  CONSTRAINT [CHK_Fine_Amount] CHECK  (([Fine_Amount]>(0)))
GO
ALTER TABLE [dbo].[Violations] CHECK CONSTRAINT [CHK_Fine_Amount]
GO
/****** Object:  StoredProcedure [dbo].[AddDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDriver]
	@first_name varchar(50),
	@last_name varchar(50),
	@middle_name varchar(50),
	@birthdate date,
	@phone nchar(12),
	@address varchar(max),
	
	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction
		insert into Drivers(First_Name, Last_Name, Middle_Name, Birthdate, Phone, Address)
		values (@first_name, @last_name, @middle_name, @birthdate, @phone, @address)

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[AddDriverLicense]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddDriverLicense]
	@licenseNumber nchar(10),
	@driver_id int,
	@category_id nchar(3),
	@issue_date date,
	@expiry_date date,
	
	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction

		insert into Driver_Licenses(License_Number, Driver_ID, Category_ID, Issue_Date, Expiry_Date)
		values (@licenseNumber, @driver_id, @category_id, @issue_date, @expiry_date)

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[AddVehicle]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddVehicle]
	@driver_id int,
	@series varchar(3),
	@registraition_number int,
	@region_code int,
	@brand varchar(100) = null,
	@model varchar(100) = null,
	@year int = null,

	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction

		insert into Vehicles(Driver_ID, Series, Registration_Number, Region_Code, Brand, Model, Year)
		values (@driver_id, @series, @registraition_number, @region_code, @brand, @model, @year)

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[AddViolation]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddViolation]
	@driver_id int,
	@vehicle_id int,
	@violation_type_id int,
	@date_time datetime,
	@place varchar(max),
	@fine_amount decimal(10,2),
	@payment_status_id int,
	
	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction

		insert into Violations(Driver_ID, Vehicle_ID, Violation_Type_ID, Date_Time, Place, Fine_Amount, Payment_Status_ID)
		values (@driver_id, @vehicle_id, @violation_type_id, @date_time, @place, @fine_amount, @payment_status_id)

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[AddViolationType]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddViolationType]
	@violation_type_id int,
	@name varchar(100) = null,
	@description varchar(max) = null,

	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction
		
		insert into Violation_Types(Violation_Name, Violation_Description)
		values (@name, @description)

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[DeleteDriver]
	@driver_id int,

	@error_message nvarchar(max) output

AS
BEGIN
if @driver_id = null
begin
	return -1
end
begin try
	begin transaction

	delete from Drivers
	where Driver_ID = @driver_id

	commit transaction
	return 0
end try
begin catch
	rollback transaction
	set @error_message = error_message()
	return -1
end catch
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteDriverLicense]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[DeleteDriverLicense]
	@license_Number nchar(10) = null,

	@error_message nvarchar(max) output

AS
BEGIN

begin try
	begin transaction

	delete from Driver_Licenses
	where License_Number = @license_Number

	commit transaction
	return 0
end try
begin catch
	rollback transaction
	set @error_message = error_message()
	return -1
end catch
END

GO
/****** Object:  StoredProcedure [dbo].[DeleteVehicle]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[DeleteVehicle]
	@vehicle_id int,

	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction
		
		delete from Vehicles
		where Vehicle_ID = @vehicle_id
		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteViolation]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[DeleteViolation]
	@violation_id int,
	
	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction

		delete from Violations
		where Violation_ID = @violation_id

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteViolationType]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[DeleteViolationType]
	@violation_type_id int,

	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction
		
		delete from Violation_Types
		where Violation_Type_ID = @violation_type_id

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[LicensesByDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[LicensesByDriver]
	@type int
AS
BEGIN
	select * 
	from GetLicensesByDriver(@type)
END
GO
/****** Object:  StoredProcedure [dbo].[RecieveFineForViolation]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ================================================
CREATE PROCEDURE [dbo].[RecieveFineForViolation]
	@violation_id int
AS
BEGIN
	update Violations
	set Payment_Status_ID = 2
	where Violation_ID = @violation_id
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDriver]
	@driver_id int,
	@first_name varchar(50) = null,
	@last_name varchar(50) = null,
	@middle_name varchar(50)  = null,
	@birthdate date  = null,
	@phone nchar(12) = null,
	@address varchar(max) = null,

	@error_message nvarchar(max) output

AS
BEGIN
if @driver_id = null
begin
	return -1
end
begin try
	begin transaction
	declare @currentPhone nchar(12)
	select @currentPhone = Phone
	from Drivers
	where Driver_ID = @driver_id

	if @currentPhone = @phone
	begin
		set @phone = null
	end

	update Drivers
	set First_Name = isnull(@first_name, First_Name), 
	    Last_Name = isnull(@last_name,Last_Name),
		Middle_Name = isnull(@middle_name, Middle_Name),
		Birthdate = isnull(@birthdate, Birthdate),
		Phone = isnull(@phone, Phone),
		Address = isnull(@address, Address)
	where Driver_ID = @driver_id

	commit transaction
	return 0
end try
begin catch
	rollback transaction
	set @error_message = error_message()
	return -1
end catch
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateDriverLicense]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateDriverLicense]
	@license_Number nchar(10) = null,
	@category_id nchar(3) = null,
	@issue_date date = null,
	@expiry_date date = null,
	@driver_id int = null,

	@error_message nvarchar(max) output

AS
BEGIN
if @driver_id = null
begin
	return -1
end
begin try
	begin transaction

	update Driver_Licenses
	set Driver_ID = isnull(@driver_id, Driver_ID),
		Category_ID = isnull(@category_id,Category_ID),
		Issue_Date = isnull(@issue_date,Issue_Date),
		Expiry_Date = isnull(@expiry_date,Expiry_Date)
	where License_Number = @license_Number

	commit transaction
	return 0
end try
begin catch
	rollback transaction
	set @error_message = error_message()
	return -1
end catch
END

GO
/****** Object:  StoredProcedure [dbo].[UpdateVehicle]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateVehicle]
	@vehicle_id int,
	@driver_id int,
	@series varchar(3),
	@registraition_number int,
	@region_code int,
	@brand varchar(100) = null,
	@model varchar(100) = null,
	@year int = null,

	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction
		update Vehicles
		set Driver_ID = isnull(@driver_id, Driver_ID),
			Series = isnull(@series, Series),
			Registration_Number = isnull(@registraition_number, Registration_Number),
			Region_Code = isnull(@region_code, Region_Code),
			Brand = isnull(@brand, Brand),
			Model = isnull(@model, Model),
			Year = isnull(@year, Year)
		where Vehicle_ID = @vehicle_id
		
		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateViolation]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[UpdateViolation]
	@violation_id int,
	@driver_id int = null,
	@vehicle_id int = null,
	@violation_type_id int = null,
	@date_time datetime = null,
	@place varchar(max) = null,
	@fine_amount decimal(10,2) = null,
	@payment_status_id int = null,
	
	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction

		update Violations
		set Driver_ID = isnull(@driver_id, Driver_ID),
			Vehicle_ID = isnull(@vehicle_id, @vehicle_id),
			Violation_Type_ID = isnull(@violation_type_id, @violation_type_id),
			Date_Time = isnull(@date_time, Date_Time),
			Fine_Amount = isnull(@fine_amount, Fine_Amount),
			Payment_Status_ID = isnull(@payment_status_id, Payment_Status_ID)
		where Violation_ID = @violation_id

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateViolationType]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[UpdateViolationType]
	@violation_type_id int,
	@name varchar(100) = null,
	@description varchar(max) = null,

	@error_message nvarchar(max) output

AS
BEGIN
	begin try
		begin transaction
		
		update Violation_Types
		set Violation_Name = isnull(@name, Violation_Name),
			Violation_Description = isnull(@description, Violation_Description)
		where Violation_Type_ID = @violation_type_id

		commit transaction

		return 0
	end try
	begin catch
		rollback transaction
		set @error_message = error_message()
		return -1
	end catch
END
GO
/****** Object:  StoredProcedure [dbo].[VehiclesByDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[VehiclesByDriver]
	@type int
AS
BEGIN
	select * 
	from GetVehiclesByDriver(@type)
END
GO
/****** Object:  StoredProcedure [dbo].[ViolationsByDriver]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ViolationsByDriver]
	@type int
AS
BEGIN
	select * 
	from GetViolationsByDriver(@type)
END
GO
/****** Object:  StoredProcedure [dbo].[ViolationsByType]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ViolationsByType]
	@type int
AS
BEGIN
	select * 
	from GetViolationsByType(@type)
END
GO
/****** Object:  StoredProcedure [dbo].[ViolationsByVehicle]    Script Date: 08.05.2024 14:28:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ViolationsByVehicle]
	@type int
AS
BEGIN
	select * 
	from GetViolationsByVehicle(@type)
END
GO
USE [master]
GO
ALTER DATABASE [TrafficViolations] SET  READ_WRITE 
GO
