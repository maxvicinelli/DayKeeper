import datetime as dt
import matplotlib.pyplot as plt
import numpy as np
from AI_calendar import set_notification_schedule_test_3

def main():
    window, late_threshold, early_threshold = 5, 3, 2
    schedule_list,events = set_notification_schedule_test_3('test3.csv', window, late_threshold, early_threshold)

    for key in schedule_list:

        dates, data, statuses = generate_data(schedule_list[key],events[key])
        fig, ax = plt.subplots(figsize=(4, 6))
        calendar_heatmap(ax, dates, data)
    plt.show()

def generate_data(schedule_list,events):
    num = len(schedule_list)
    #data = np.random.randint(0, 20, num)
    start = dt.datetime(2022, 2, 7)
    dates = [start + dt.timedelta(days=i) for i in range(num)]
    return dates, schedule_list,events

def calendar_array(dates, data):
    i, j = zip(*[d.isocalendar()[1:] for d in dates])
    i = np.array(i) - min(i)
    j = np.array(j) - 1
    ni = max(i) + 1

    calendar = np.nan * np.zeros((ni, 7))
    calendar[i, j] = data
    return i, j, calendar


def calendar_heatmap(ax, dates, data):
    i, j, calendar = calendar_array(dates, data)
    im = ax.imshow(calendar, interpolation='none', cmap='summer')
    label_days(ax, dates, i, j, calendar)
    label_months(ax, dates, i, j, calendar)
    ax.figure.colorbar(im)

def label_days(ax, dates, i, j, calendar):
    ni, nj = calendar.shape
    day_of_month = np.nan * np.zeros((ni, 7))
    day_of_month[i, j] = [d.day for d in dates]

    for (i, j), day in np.ndenumerate(day_of_month):
        if np.isfinite(day):
            ax.text(j, i, int(day), ha='center', va='center')

    ax.set(xticks=np.arange(7), 
           xticklabels=['M', 'T', 'W', 'R', 'F', 'S', 'S'])
    ax.xaxis.tick_top()

def label_months(ax, dates, i, j, calendar):
    month_labels = np.array(['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                             'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])
    months = np.array([d.month for d in dates])
    uniq_months = sorted(set(months))
    yticks = [i[months == m].mean() for m in uniq_months]
    labels = [month_labels[m - 1] for m in uniq_months]
    ax.set(yticks=yticks)
    ax.set_yticklabels(labels, rotation=90)

main()