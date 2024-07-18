# Lok Sabha Election Analysis (2014 and 2019)

The Lok Sabha, the lower house of India's Parliament, has 543 seats. Members are elected by the public to represent them. The Lok Sabha makes laws, discusses national issues, and controls government spending. Its members, called Members of Parliament (MPs), are elected every five years. 

Data Cleaning:
1. Updated the null values in the csv file to 0 before importing to sql(there were null values present only for the NOTA category).
2. As Andhra Pradesh got bifurcated in 2014, the constituencies present in the constituency_wise_results_2014 were changed accordingly.
3. Names of the following constituencies were misspelled in the table which were accordingly rectified to match the names in both the tables:

Gauhati -> Guwahati

Bikaner -> Bikaner(SC)

Dadar And Nagar -> Dadra & Nagar Haveli

5. There are 2 state names missing from the constituency_wise_results_2014 : Chhattisgarh and Odisha.


Queries:

Identifying missing data (2014)

![image](https://github.com/user-attachments/assets/836cae19-fde0-4a95-ac93-97e4f376ebf0)

    
Identifying missing data (2019)

 ![image](https://github.com/user-attachments/assets/686090fa-aa02-46e0-a8ef-b73c42e07d50)

 
**Q1)** List top 5 / bottom 5 constituencies of 2014 and 2019 in terms of voter turnout ratio

Top 5 constituencies of 2014

![image](https://github.com/user-attachments/assets/f33e65ce-7d18-4534-ad5d-4fdcddbec99a)

Top 5 constituencies of 2019

![image](https://github.com/user-attachments/assets/a3b17bbc-a23f-4f09-b8cf-7f13e658527b)

Bottom 5 constituencies of 2014

![image](https://github.com/user-attachments/assets/b6998f44-cc1a-4a31-ac1b-f1fa1afc3571)

Bottom 5 constituencies of 2019

![image](https://github.com/user-attachments/assets/e398f587-5600-4800-aa86-00d82c47f1dc)


**Q2)** List top 5 / bottom 5 states of 2014 and 2019 in terms of voter turnout ratio

Top 5 states of 2014

![image](https://github.com/user-attachments/assets/abfee7c9-0689-4a3b-8cf5-1b08f06f488c)

Top 5 states of 2019

![image](https://github.com/user-attachments/assets/2bf1f350-9eb2-4b2b-8afd-457cdf52dcae)

Bottom 5 states of 2014

![image](https://github.com/user-attachments/assets/078b589a-2aa9-4edd-8171-a2b1bce5dab0)

Bottom 5 states of 2019

![image](https://github.com/user-attachments/assets/eb16e217-cd40-49eb-a840-6224d6557b1c)


**Q3)** Which constituencies have elected the same party for two consecutive elections, rank them by % of votes to that winning party in 2019

![image](https://github.com/user-attachments/assets/9bf72d1a-f35b-40dd-bce2-03748cf5f1f2)


**Q4)** Which constituencies have voted for different parties in two elections (list top 10 based on difference (2019-2014) in winner vote percentage in two elections)

![image](https://github.com/user-attachments/assets/64cce904-415a-48ac-8308-afae08a24985)


**Q5)** Top 5 candidates based on margin difference with runners in 2014 and 2019

2014

![image](https://github.com/user-attachments/assets/e7230107-fc18-4e41-bcdc-5dbee8cfb452)

2019

![image](https://github.com/user-attachments/assets/11f99860-d245-48a4-9c70-ce65cab80320)


**Q6)** % Split of votes of parties between 2014 vs 2019 at national level

![image](https://github.com/user-attachments/assets/6bd03c56-be89-4315-9ec9-7bc2ccb1fe39)


**Q7)** % Split of votes of parties between 2014 vs 2019 at state level

2014

![image](https://github.com/user-attachments/assets/2b396f60-0092-458f-a37b-c401246b71ae)

2019

![image](https://github.com/user-attachments/assets/0bf020f6-6a45-468b-9dce-9798c0f169f0)


**Q8)** List top 5 constituencies for two major national parties where they have gained vote share in 2019 as compared to 2014

BJP

![image](https://github.com/user-attachments/assets/c5e2bbd8-7b51-4190-ad92-e824cf72571c)

INC

![image](https://github.com/user-attachments/assets/408d19cb-5622-4898-8cfb-ac8d79db45af)


**Q9)** List top 5 constituencies for two major national parties where they have lost vote share in 2019 as compared to 2014

BJP

![image](https://github.com/user-attachments/assets/1e07753b-e2f7-4a36-9413-0a6842daf349)

INC

![image](https://github.com/user-attachments/assets/fb8d4fca-ad4d-497d-b403-d363ae2b4abe)


**Q10)** Which constituency has voted the most for NOTA

2014

![image](https://github.com/user-attachments/assets/6d321926-6845-4ea3-81f7-994aa7c8e3c5)

2019

![image](https://github.com/user-attachments/assets/7d34dc36-b7af-4d35-b15a-78e75aa123dd)


**Q11)** Which constituencies have elected candidates whose party has less than 10% vote share at state level in 2019

![image](https://github.com/user-attachments/assets/9c71d0ec-5aaa-4a93-8a85-afaf64dc0b6d)
