-- Here we will use the capetown_waste_management as our database name
USE  capetown_waste_management;

-- Table for waste type 
CREATE TABLE Waste_Type (
    waste_type_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    category VARCHAR(50),
    unit VARCHAR(50)
)ENGINE=InnoDB;


-- Table for Resident 

CREATE TABLE Resident (
    resident_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(100),
    contact_info VARCHAR(15),           -- VARCHAR instead of INT
    pickup_schedule DATETIME,
    notification_opt_in VARCHAR(50)
)ENGINE=InnoDB;




-- Table: Recycling_Centre

CREATE TABLE Recycling_Centre (
    centre_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    location VARCHAR(100),
    contact_info VARCHAR(15)
)ENGINE=InnoDB;


--  Table: Vehicle

CREATE TABLE Vehicle (
    vehicle_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    registration_no VARCHAR(50) NOT NULL,
    capacity INT(11),
    type VARCHAR(50)
)ENGINE=InnoDB;


-- Table: Route

CREATE TABLE Route (
    route_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    area VARCHAR(100),
    start_point VARCHAR(100),
    end_point VARCHAR(100)
)ENGINE=InnoDB;


-- Table: Driver

CREATE TABLE Driver (
    driver_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    vehicle_id INT(11),
    licence_no VARCHAR(50),
    route_id INT(11),
    name VARCHAR(50) NOT NULL,
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (route_id) REFERENCES Route(route_id)
        ON DELETE SET NULL ON UPDATE CASCADE
)ENGINE=InnoDB;


-- Table: DriverRouteAssignment

CREATE TABLE DriverRouteAssignment (
    driver_id INT(11),
    route_id INT(11),
    assignment_date DATETIME,
    shift_time DATETIME,
    status VARCHAR(50),
    PRIMARY KEY (driver_id, route_id),
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (route_id) REFERENCES Route(route_id)
        ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB;


-- Table: Collection_Log

CREATE TABLE Collection_Log (
    log_id INT(11) PRIMARY KEY AUTO_INCREMENT,
    resident_id VARCHAR(50),
    driver_id INT(11),
    waste_type_id INT(11),
    centre_id INT(11),
    date DATETIME,
    volume_collected DOUBLE(11,2),
    status VARCHAR(50),
    FOREIGN KEY (resident_id) REFERENCES Resident(resident_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (driver_id) REFERENCES Driver(driver_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (waste_type_id) REFERENCES Waste_Type(waste_type_id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (centre_id) REFERENCES Recycling_Centre(centre_id)
        ON DELETE SET NULL ON UPDATE CASCADE
)ENGINE=InnoDB;





INSERT INTO Waste_Type (name, category, unit)
VALUES ('Plastic', 'Recyclable', 'kg'),
       ('Organic', 'Compostable', 'kg');
      

INSERT INTO Resident VALUES
('R001', 'John Doe', '123 Main Street', '0723456789', '2025-10-10 08:00:00', 'Yes'),
('R002', 'Jane Smith', '456 Oak Avenue', '0711111111', '2025-10-11 09:30:00', 'No');

INSERT INTO Recycling_Centre (name, location, contact_info)
VALUES ('EcoCentre', 'Downtown', '0115551234');

INSERT INTO Vehicle (registration_no, capacity, type)
VALUES ('GP1234', 1000, 'Truck'),
       ('GP5678', 800, 'Van');

INSERT INTO Route (name, area, start_point, end_point)
VALUES ('Route A', 'Central Zone', 'Depot', 'Recycling Centre'),
       ('Route B', 'South Zone', 'Depot', 'Recycling Centre');

INSERT INTO Driver (vehicle_id, licence_no, route_id, name)
VALUES (1, 'LIC12345', 1, 'Mike Smith'),
       (2, 'LIC67890', 2, 'Anna Johnson');

INSERT INTO DriverRouteAssignment VALUES
(1, 1, '2025-10-09 07:00:00', '2025-11-09 07:00:00', 'Active'),
(2, 2, '2025-10-09 09:00:00', '2025-10-23 09:00:00', 'Active');

INSERT INTO Collection_Log (resident_id, driver_id, waste_type_id, centre_id, date, volume_collected, status)
VALUES ('R001', 1, 1, 1, '2025-10-09 10:00:00', 45.50, 'Completed'),
       ('R002', 2, 2, 1, '2025-10-09 11:00:00', 30.25, 'Pending');
       
       
	-- Normalization 
SELECT r.name AS Resident,d.name AS Driver, wt.name AS WasteType,cl.status 
FROM Collection_Log cl JOIN Resident r ON cl.resident_id=r.resident_id 
JOIN Driver d ON cl.driver_id=d.driver_id 
JOIN Waste_Type wt ON cl.waste_type_id= wt.waste_type_id;


-- The following are the functionalitions:


-- This shows total waste collected by waste type 

SELECT wt.name AS WasteType, SUM(cl.volume_collected) AS TotalVolumeKg
FROM Collection_Log cl
JOIN Waste_Type wt ON cl.waste_type_id=wt.waste_type_id
GROUP BY wt.name;       

-- This shows total waste collected by driver 

SELECT d.name AS Driver,SUM(cl.volume_collected) AS TotalCollectedKg
FROM Collection_Log cl JOIN Driver d ON cl.driver_id=d.driver_id
GROUP BY d.name; 

-- This shows total waste collected by route 
SELECT r.name AS RouteName,SUM(cl.volume_collected ) AS TotalCollectedKg 
FROM Collection_Log cl 
JOIN Driver d ON cl.driver_id=d.driver_id
JOIN Route r ON d.route_id=r.route_id
GROUP BY r.name ;

-- This shows which driver collected which waste type 
SELECT d.name AS Driver,wt.name AS WasteType , SUM(cl.volume_collected) AS TotalVolumeKg
FROM Collection_Log cl 
JOIN Driver d ON cl.driver_id = d.driver_id 
JOIN Waste_Type wt ON cl.waste_type_id= wt.waste_type_id
GROUP BY d.name,wt.name ;

-- This shows pending and  completed collection events 

SELECT 
status AS CollectionStatus, COUNT(*) AS NumberOfEvents 
FROM Collection_Log 
GROUP BY status;   


-- This shows total waste collected on a specific date In this we use '2025-10-09'  


SELECT DATE(cl.date) AS EventDate, wt.name as wasteType,
SUM(cl.volume_collected) AS TotalVolumeKg
FROM Collection_Log cl 
JOIN Waste_Type wt ON cl.waste_type_id=wt.waste_type_id
WHERE DATE(cl.date)='2025-10-09'  -- You can change for the specific date you want 
GROUP BY wt.name, DATE (cl.date);


-- This shows each residents waste collected 




SELECT r.name AS Resident, 
wt.name AS WasteType,cl.date AS CollectionDate,cl.volume_collected ,cl.status
FROM Collection_Log cl 

JOIN Resident r ON cl.resident_id=r.resident_id
JOIN Waste_Type wt ON cl.waste_type_id=wt.waste_type_id
ORDER BY r.name,cl.date;

