import matplotlib.pyplot as plt
import numpy as np

# Visualization 1: Life Expectancy Disparities
fig, ax = plt.subplots()
categories = ['High-Income Countries', 'Low-Income Countries', 'India']
values = [82, 64, 70]
bars = ax.bar(categories, values, color=['blue', 'red', 'green'])
ax.set_ylabel('Life Expectancy (Years)')
ax.set_title('Global Life Expectancy Disparities')
ax.bar_label(bars)
plt.savefig('life_expectancy_disparities.png')
plt.close()

# Visualization 2: Under-5 Mortality
fig, ax = plt.subplots()
categories = ['High-Income', 'Low-Income', 'India']
values = [5, 40, 28]
bars = ax.bar(categories, values, color=['blue', 'red', 'green'])
ax.set_ylabel('Under-5 Mortality (per 1000)')
ax.set_title('Under-5 Mortality Rates')
ax.bar_label(bars)
plt.savefig('under5_mortality.png')
plt.close()

# Visualization 3: Malnutrition in India
fig, ax = plt.subplots()
categories = ['Rural', 'Urban', 'Scheduled Caste', 'General']
values = [40, 25, 45, 20]
bars = ax.bar(categories, values, color=['orange', 'purple', 'brown', 'pink'])
ax.set_ylabel('Malnutrition Rate (%)')
ax.set_title('Malnutrition by Socioeconomic Groups in India')
ax.bar_label(bars)
plt.savefig('malnutrition_india.png')
plt.close()

# Visualization 4: Social Gradient in Health
fig, ax = plt.subplots()
positions = np.arange(5)
socioeconomic = ['Lowest', 'Low', 'Middle', 'High', 'Highest']
health_outcomes = [80, 70, 60, 50, 40]  # Hypothetical health score
ax.plot(positions, health_outcomes, marker='o', color='red')
ax.set_xticks(positions)
ax.set_xticklabels(socioeconomic)
ax.set_ylabel('Health Outcome Score')
ax.set_title('Social Gradient in Health')
plt.savefig('social_gradient.png')
plt.close()

# Visualization 5: Cultural Determinants Impact
fig, ax = plt.subplots()
labels = ['Beliefs', 'Gender Norms', 'Caste', 'Language']
sizes = [25, 30, 25, 20]
colors = ['gold', 'yellowgreen', 'lightcoral', 'lightskyblue']
ax.pie(sizes, labels=labels, colors=colors, autopct='%1.1f%%', startangle=140)
ax.set_title('Impact of Cultural Determinants on Health')
plt.savefig('cultural_impact.png')
plt.close()

# Visualization 6: Indian Programs Impact
fig, ax = plt.subplots()
programs = ['NHM', 'Ayushman Bharat', 'Swachh Bharat']
before = [100, 100, 100]
after = [70, 60, 30]
x = np.arange(len(programs))
width = 0.35
ax.bar(x - width/2, before, width, label='Before', color='red')
ax.bar(x + width/2, after, width, label='After', color='green')
ax.set_xlabel('Programs')
ax.set_ylabel('Health Disparity Index')
ax.set_title('Impact of Indian Health Programs')
ax.set_xticks(x)
ax.set_xticklabels(programs)
ax.legend()
plt.savefig('programs_impact.png')
plt.close()

print("Visualization assets saved as PNG files.")
