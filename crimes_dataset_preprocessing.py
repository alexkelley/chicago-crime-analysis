import urllib.request
import csv
import datetime

with open(r'\Users\Alex\Downloads\Crimes_-_2001_to_present.csv', 'r') as f:
    reader = csv.reader(f)
    export_file = ''
    count = 0
    for row in reader:
        temp_row = ''
        
        for i in [2, 5, 7, 8, 14]:
            if i == 2 and row[i] != 'Date':
                date = row[i]
                new_date = datetime.datetime.strptime(date, '%m/%d/%Y %I:%M:%S %p')
                row[i] = new_date.month
                if row[i] in (1, 2, 3, 10, 11, 12):
                    row[i] = str(0)
                else:
                    row[i] = str(1)
                
            temp_row += row[i].strip() + ','

        count += 1
        export_file += temp_row[:-1] + '\n'
        if count % 100000 == 0:
            print('row: {}'.format(count))

with open('crimes_month_num.csv', 'w') as text_file:
    text_file.write(export_file)
