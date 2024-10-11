-- ================================================
-- Reversing IDs in a Table and Resetting Auto-Increment
-- ================================================

-- Temporarily disable foreign key checks to avoid conflicts when modifying primary keys
SET foreign_key_checks = 0;

-- ================================================
-- Step 1: Calculate and store the maximum original ID value
-- This is necessary to calculate the reversed ID values later.
-- ================================================
SET @original_max_id = (SELECT MAX(id) FROM your_table_name);

-- ================================================
-- Step 2: Update the 'id' column with temporary negative values
-- This avoids conflicts during the update by ensuring all IDs are unique.
-- ================================================
UPDATE your_table_name
SET id = -id;

-- ================================================
-- Step 3: Reverse the IDs using the maximum original ID value
-- The new IDs will be based on the maximum original ID value.
-- ================================================
UPDATE your_table_name
SET id = @original_max_id + id + 1;

-- ================================================
-- RESET AUTO INCREMENT
-- ================================================

-- ================================================
-- Step 1: Find the current maximum ID value in the table
-- This value will be used to set the next auto-increment value.
-- ================================================
SELECT MAX(id) INTO @new_max_id FROM your_table_name;

-- ================================================
-- Step 2: Set the new auto-increment value based on the maximum ID
-- This ensures that future inserts will continue from the correct value.
-- ================================================
SET @new_auto_increment = @new_max_id + 1;
SET @sql = CONCAT('ALTER TABLE your_table_name AUTO_INCREMENT = ', @new_auto_increment);

-- ================================================
-- Step 3: Prepare and execute the dynamic SQL statement
-- The dynamic statement is necessary because MySQL does not allow variables
-- directly in the ALTER TABLE statement for setting auto-increment.
-- ================================================
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Re-enable foreign key checks after all updates are complete
SET foreign_key_checks = 1;
