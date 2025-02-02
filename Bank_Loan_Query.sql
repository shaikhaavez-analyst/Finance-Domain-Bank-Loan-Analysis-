
-- BANK LOAN REPORT QUERY

SELECT * FROM bank_loan_data

-- Total Loan Applications
SELECT COUNT(id) AS Total_Loan_Applications FROM bank_loan_data 


-- Month-To-Date Loan Application
SELECT COUNT(id) AS MTD_Total_Loan_Applications FROM bank_loan_data 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021

-- Previous-Month-To-Date Loan Application
SELECT COUNT(id) AS PMTD_Total_Loan_Applications FROM bank_loan_data 
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021

-- (MoM) Month-Over-Month Analysis

SELECT
*,
ROUND(
	CAST((CurrentMonthLoanApplication - PreviousMonthLoanApplication) AS FLOAT) 
	/ PreviousMonthLoanApplication * 100, 2)
	AS PercentageChange

FROM (
	SELECT 
	MONTH(issue_date) Months,
	COUNT(id) CurrentMonthLoanApplication,
	LAG (COUNT(id)) OVER (ORDER BY MONTH(issue_date)) PreviousMonthLoanApplication
	FROM bank_loan_data 
	GROUP BY MONTH(issue_date)
)t

------------------------------------------------------------------------------------------------

-- Total Funded Amount
SELECT SUM(loan_amount) AS Total_Loan_Amount FROM bank_loan_data 


-- Month-To-Date Loan Amount
SELECT SUM(loan_amount) AS MTD_Total_Loan_Amount FROM bank_loan_data 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021


-- Previous-Month-To-Date Loan Application
SELECT SUM(loan_amount) AS PMTD_Total_Loan_Amount FROM bank_loan_data 
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


-- (MoM) Month-Over-Month Analysis for Total Funded Amount

SELECT
*,
ROUND(
	CAST((CurrentMonthLoanAmount - PreviousMonthLoanAmount) AS FLOAT) 
	/ PreviousMonthLoanAmount * 100, 2)
	AS PercentageChange

FROM (
	SELECT 
	MONTH(issue_date) Months,
	SUM(loan_amount) CurrentMonthLoanAmount,
	LAG (SUM(loan_amount)) OVER (ORDER BY MONTH(issue_date)) PreviousMonthLoanAmount
	FROM bank_loan_data 
	GROUP BY MONTH(issue_date)
)t

----------------------------------------------------------------------------------------------------

-- Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Received FROM bank_loan_data 


-- Month-To-Date Loan Amount Received
SELECT SUM(total_payment) AS MTD_Total_Loan_Amount_Received FROM bank_loan_data 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021


-- Previous-Month-To-Date Loan Amount Received
SELECT SUM(total_payment) AS MTD_Total_Loan_Amount_Received FROM bank_loan_data 
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


---------------------------------------------------------------------------------------------------

-- Average Intrest Rate
SELECT ROUND(AVG(int_rate), 4) * 100 AS AvgIntrestRate FROM bank_loan_data 


-- Month-To-Date Average Intrest Rate
SELECT ROUND(AVG(int_rate), 4) * 100 AS MTD_Total_Average_Intrest_Rate FROM bank_loan_data 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021


-- Previous-Month-To-Date Average Intrest Rate
SELECT ROUND(AVG(int_rate), 4) * 100 AS PMTD_Total_Average_Intrest_Rate FROM bank_loan_data 
WHERE MONTH(issue_date) = 11 AND YEAR(issue_date) = 2021


-- (MoM) Month-Over-Month Analysis for Average Intrest Rate
SELECT
*,
	ROUND((CurrentMonthIntrest - PreviousMonthIntrest) / PreviousMonthIntrest * 100, 2)
	AS PercentageChange

FROM (
	SELECT 
	MONTH(issue_date) Months,
	ROUND(AVG(int_rate), 4) * 100 CurrentMonthIntrest,
	LAG (ROUND(AVG(int_rate), 4) * 100) OVER (ORDER BY MONTH(issue_date)) PreviousMonthIntrest
	FROM bank_loan_data 
	GROUP BY MONTH(issue_date)
)t


-----------------------------------------------------------------------------------------------------


-- Average Dept-to-Income Ratio (DTI)
SELECT ROUND(AVG(dti) * 100, 2) AS AvgDTI FROM bank_loan_data 


-- Month-To-Date Average Dept-to-Income Ratio (DTI)
SELECT ROUND(AVG(dti) * 100, 2) AS MTD_AvgDTI FROM bank_loan_data 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021


-- Previous-Month-To-Date Average Dept-to-Income Ratio (DTI)
SELECT ROUND(AVG(dti) * 100, 2) AS PMTD_AvgDTI FROM bank_loan_data 
WHERE MONTH(issue_date) = 12 AND YEAR(issue_date) = 2021


-- (MoM) Month-Over-Month Analysis for Average Dept-to-Income Ratio (DTI)
SELECT
*,
	ROUND((CurrentMonthAverage_DTI - PreviousMonthAverage_DTI) / PreviousMonthAverage_DTI * 100, 2)
	AS PercentageChange

FROM (
	SELECT 
	MONTH(issue_date) Months,
	ROUND(AVG(dti) * 100, 2) CurrentMonthAverage_DTI,
	LAG (ROUND(AVG(dti) * 100, 2)) OVER (ORDER BY MONTH(issue_date)) PreviousMonthAverage_DTI
	FROM bank_loan_data 
	GROUP BY MONTH(issue_date)
)t


/*
-------------------------------------------------------------------------------------------------------
*******************************************************************************************************
*******************************************************************************************************
-------------------------------------------------------------------------------------------------------
*/


-- LOAN STATUS ANALYSIS GOOD LOAN & BAD LOAN KPI`s

SELECT * FROM bank_loan_data

SELECT DISTINCT loan_status FROM bank_loan_data

-- GOOD LOAN

-- Good Loan Application Percentage
SELECT 
	(COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100)
	/ COUNT(id)
FROM bank_loan_data


-- Good Loan Application
SELECT 
	COUNT(id) Total_Good_Loan_Application
	FROM bank_loan_data
	WHERE loan_status IN ('Fully Paid', 'Current')


-- Good Loan Funded Amount
SELECT 
	SUM(loan_amount) Total_Good_Loan_Funded_Amount
	FROM bank_loan_data
	WHERE loan_status IN ('Fully Paid', 'Current')


-- Good Loan Total Received Amount
SELECT 
	SUM(total_payment) Total_Good_Loan_Received_Amount
	FROM bank_loan_data
	WHERE loan_status IN ('Fully Paid', 'Current')

-- BAD LOAN

-- Bad Loan Application Percentage
SELECT 
	(SELECT COUNT(id) FROM bank_loan_data WHERE loan_status ='Charged Off') * 100 / COUNT(id) 
	AS Bad_Loan_Application_Percentage 
	FROM bank_loan_data


-- Bad Loan Application
SELECT 
	COUNT(id) Total_Good_Loan_Application
	FROM bank_loan_data
	WHERE loan_status = 'Charged Off'

-- Bad Loan Funded Amount
SELECT 
	SUM(loan_amount) Total_Bad_Loan_Funded_Amount
	FROM bank_loan_data
	WHERE loan_status IN ('Charged Off')

-- Bad Loan Total Received Amount
SELECT 
	SUM(total_payment) Total_Bad_Loan_Received_Amount
	FROM bank_loan_data
	WHERE loan_status IN ('Charged Off')


/*
-------------------------------------------------------------------------------------------------------
*******************************************************************************************************
*******************************************************************************************************
-------------------------------------------------------------------------------------------------------
*/


-- OVERVIEW

SELECT * FROM bank_loan_data

-- Monthly Trends by Issue Date 
SELECT 
	*,
	(Total_Received_Amount - Total_Funded_Amount) As Profit_earn,
	ROUND(CAST((Total_Received_Amount - Total_Funded_Amount) AS FLOAT )
		/ Total_Funded_Amount * 100, 2)
FROM (

	SELECT 
		MONTH(issue_date) AS Month_Number,
		DATENAME(MONTH, issue_date) AS Month_Name,
		COUNT(id) AS Total_Loan_Application,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
	FROM bank_loan_data
	GROUP BY MONTH(issue_date), DATENAME(MONTH, issue_date)
)t
ORDER BY Month_Number



-- Regional Analysis by State
SELECT 
		address_state,
		COUNT(id) AS Total_Loan_Application,
		SUM(loan_amount) AS Total_Funded_Amount,
		SUM(total_payment) AS Total_Received_Amount
	FROM bank_loan_data
	GROUP BY address_state
	ORDER BY COUNT(id) DESC

-- Loan Term
SELECT 
	term,
	COUNT(id) AS Total_Loan_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY term
ORDER BY term


-- Emp_length
SELECT 
	emp_length,
	COUNT(id) AS Total_Loan_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY emp_length
ORDER BY COUNT(id) DESC


-- Loan Purpose Breakdown Query
SELECT 
	purpose,
	COUNT(id) AS Total_Loan_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY purpose
ORDER BY COUNT(id) DESC


-- Home Ownership Analysis
SELECT 
	home_ownership,
	COUNT(id) AS Total_Loan_Application,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Received_Amount
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY COUNT(id) DESC

