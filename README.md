# credit-card-clustering-R-PYTHON-
The clustering analysis on credit card data to develop customer segmentation and to define marketing strategy Edwisor
1.1 Problem Statement<br>
This case requires trainees to develop a customer segmentation to define<br>
marketing strategy. The sample dataset summarizes the usage behaviour of about<br>
9000 active credit card holders during the last 6 months. The file is at a customer
level with 18 behavioural variables. I found that there are four types of purchase
behaviour so I decided to cluster based on their purchase behaviour.
1.2 Data
Our task is to develop customer segmentation to deploy several marketing
strategies based on segment behaviour.
CUST_ID BALANCE BALANCE_FREQUENCY PURCHASES ONEOFF_PURCHASES INSTALLMENTS_PURCHASES
C10001 40.900749 0.818182 95.4 0 95.4
C10002 3202.467416 0.909091 0 0 0
C10003 2495.148862 1 773.17 773.17 0
C10004 1666.670542 0.636364 1499 1499 0
C10005 817.714335 1 16 16 0
C10006 1809.828751 1 1333.28 0 1333.28
CASH_ADVANCE
PURCHASES_
FREQUENCY
ONEOFF_PURCHASES
_FREQUENCY
PURCHASES_INSTALL
MENTS_FREQUENCY
CASH_ADVANCE
_FREQUENCY
CASH_ADVANCE_
TRX
PURCHASES_
TRX
0 0.166667 0 0.083333 0 0 2
6442.945483 0 0 0 0.25 4 0
0 1 1 0 0 0 12
205.788017 0.083333 0.083333 0 0.083333 1 1
0 0.083333 0.083333 0 0 0 1
0 0.666667 0 0.583333 0 0 8
CREDIT_LIMIT PAYMENTS
MINIMUM_PAY
MENTS
PRC_FULL_P
AYMENT TENURE
1000 201.802084 139.509787 0 12
7000 4103.032597 1072.340217 0.222222 12
7500 622.066742 627.284787 0 12
7500 0 0 12
1200 678.334763 244.791237 0 12
1800 1400.05777 2407.246035 0 12
4
The variable present in this data are
The details of variable present in the dataset are as follows –
Number of attributes:
● CUST_ID -Credit card holder ID
● BALANCE Monthly average balance (based on daily balance averages)
● BALANCE_FREQUENCY Ratio of last 12 months with balance
● PURCHASES Total purchase amount spent during last 12 months
● ONEOFF_PURCHASES Total amount of one-off purchases
● INSTALLMENTS_PURCHASES Total amount of installment purchases
● CASH_ADVANCE Total cash-advance amount
● PURCHASES_ FREQUENCY-Frequency of purchases (percentage of months
with at least on purchase)
● ONEOFF_PURCHASES_FREQUENCY Frequency of one-off-purchases
● PURCHASES_INSTALLMENTS_FREQUENCY Frequency of installment
purchases
● CASH_ADVANCE_ FREQUENCY Cash-Advance frequency
● AVERAGE_PURCHASE_TRX Average amount per purchase transaction
● CASH_ADVANCE_TRX Average amount per cash-advance transaction
CUST_ID
BALANCE
BALANCE_FREQUENCY
PURCHASES
ONEOFF_PURCHASES
INSTALLMENTS_PURCHASES
CASH_ADVANCE
PURCHASES_FREQUENCY
ONEOFF_PURCHASES_FREQ
UENCY
PURCHASES_INSTALLMENTS
_FREQUENCY
CASH_ADVANCE_FREQUENC
Y
CASH_ADVANCE_TRX
PURCHASES_TRX
CREDIT_LIMIT
PAYMENTS
MINIMUM_PAYMENTS
PRC_FULL_PAYMENT
TENURE
5
● PURCHASES_TRX Average amount per purchase transaction
● CREDIT_LIMIT Credit limit
● PAYMENTS - Total payments (due amount paid by the customer to decrease their statement balance) in the period
● MINIMUM_PAYMENTS - Total minimum payments due in the period.
● PRC_FULL_PAYMENT - Percentage of months with full payment of the due statement balance
● TENURE - Number of months as a customer Evaluation B
