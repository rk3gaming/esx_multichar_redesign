<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  
  export let value: string = '';
  export let minAge: number = 16;
  
  const dispatch = createEventDispatcher();
  
  let isOpen = false;
  let currentDate = new Date();
  let selectedDate: Date | null = value ? new Date(value) : null;
  let showMonthPicker = false;
  let showYearPicker = false;
  
  const maxDate = new Date();
  maxDate.setFullYear(maxDate.getFullYear() - minAge);
  
  const minDate = new Date();
  minDate.setFullYear(minDate.getFullYear() - 100);
  
  const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];
  
  const years = Array.from(
    { length: maxDate.getFullYear() - minDate.getFullYear() + 1 },
    (_, i) => maxDate.getFullYear() - i
  );
  
  function getDaysInMonth(year: number, month: number) {
    return new Date(year, month + 1, 0).getDate();
  }
  
  function getFirstDayOfMonth(year: number, month: number) {
    return new Date(year, month, 1).getDay();
  }
  
  function formatDate(date: Date): string {
    return date.toISOString().split('T')[0];
  }
  
  function selectDate(date: Date) {
    if (date >= minDate && date <= maxDate) {
      selectedDate = date;
      value = formatDate(date);
      dispatch('select', { date: value });
      isOpen = false;
    }
  }
  
  function selectMonth(month: number) {
    currentDate = new Date(currentDate.getFullYear(), month);
    showMonthPicker = false;
  }
  
  function selectYear(year: number) {
    currentDate = new Date(year, currentDate.getMonth());
    showYearPicker = false;
  }
  
  function previousMonth() {
    currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() - 1);
  }
  
  function nextMonth() {
    currentDate = new Date(currentDate.getFullYear(), currentDate.getMonth() + 1);
  }
  
  function isDateDisabled(date: Date): boolean {
    return date < minDate || date > maxDate;
  }
  
  function handleClickOutside(event: MouseEvent) {
    const target = event.target as HTMLElement;
    if (!target.closest('.calendar-container')) {
      isOpen = false;
      showMonthPicker = false;
      showYearPicker = false;
    }
  }
  
  function handleMonthClick(event: MouseEvent) {
    event.stopPropagation();
    showMonthPicker = !showMonthPicker;
    showYearPicker = false;
  }
  
  function handleYearClick(event: MouseEvent) {
    event.stopPropagation();
    showYearPicker = !showYearPicker;
    showMonthPicker = false;
  }
  
  function handlePickerClick(event: MouseEvent) {
    event.stopPropagation();
  }
  
  function handleKeydown(event: KeyboardEvent, action: () => void) {
    if (event.key === 'Enter' || event.key === ' ') {
      event.preventDefault();
      action();
    }
  }

  function handleMonthKeydown(event: KeyboardEvent) {
    handleKeydown(event, () => handleMonthClick(event as unknown as MouseEvent));
  }

  function handleYearKeydown(event: KeyboardEvent) {
    handleKeydown(event, () => handleYearClick(event as unknown as MouseEvent));
  }

  function handleDateKeydown(event: KeyboardEvent, date: Date) {
    handleKeydown(event, () => selectDate(date));
  }
  
  $: daysInMonth = getDaysInMonth(currentDate.getFullYear(), currentDate.getMonth());
  $: firstDay = getFirstDayOfMonth(currentDate.getFullYear(), currentDate.getMonth());
  $: daysArray = Array.from({ length: daysInMonth }, (_, i) => i + 1);
  $: emptyDays = Array.from({ length: firstDay }, (_, i) => i);
</script>

<svelte:window on:click={handleClickOutside} />

<div class="calendar-container">
  <div 
    class="calendar-input" 
    on:click={() => isOpen = !isOpen}
    on:keydown={(e) => handleKeydown(e, () => isOpen = !isOpen)}
    role="button"
    tabindex="0"
  >
    <input 
      type="text" 
      readonly 
      value={selectedDate ? formatDate(selectedDate) : ''} 
      placeholder="Select date"
    />
  </div>
  
  {#if isOpen}
    <div 
      class="calendar-dropdown" 
      on:click={handlePickerClick} 
      on:keydown={(e) => e.key === 'Escape' && (isOpen = false)}
      role="dialog" 
      aria-label="Date picker"
      tabindex="-1"
    >
      <div class="calendar-header">
        <button 
          type="button"
          on:click={previousMonth}
          on:keydown={(e) => handleKeydown(e, previousMonth)}
        >
          &lt;
        </button>
        <div class="header-selectors">
          <button 
            type="button"
            class="month-year-btn" 
            on:click={handleMonthClick}
            on:keydown={handleMonthKeydown}
          >
            {months[currentDate.getMonth()]}
          </button>
          <button 
            type="button"
            class="month-year-btn" 
            on:click={handleYearClick}
            on:keydown={handleYearKeydown}
          >
            {currentDate.getFullYear()}
          </button>
        </div>
        <button 
          type="button"
          on:click={nextMonth}
          on:keydown={(e) => handleKeydown(e, nextMonth)}
        >
          &gt;
        </button>
      </div>
      
      {#if showMonthPicker}
        <div class="picker-grid month-picker">
          {#each months as month, i}
            <button 
              type="button"
              class="picker-item" 
              class:selected={currentDate.getMonth() === i}
              on:click|stopPropagation={() => selectMonth(i)}
              on:keydown={(e) => handleKeydown(e, () => selectMonth(i))}
            >
              {month.slice(0, 3)}
            </button>
          {/each}
        </div>
      {:else if showYearPicker}
        <div class="picker-grid year-picker">
          {#each years as year}
            <button 
              type="button"
              class="picker-item" 
              class:selected={currentDate.getFullYear() === year}
              on:click|stopPropagation={() => selectYear(year)}
              on:keydown={(e) => handleKeydown(e, () => selectYear(year))}
            >
              {year}
            </button>
          {/each}
        </div>
      {:else}
        <div class="calendar-grid">
          {#each days as day}
            <div class="calendar-day-header">{day}</div>
          {/each}
          
          {#each emptyDays as _}
            <div class="calendar-day empty"></div>
          {/each}
          
          {#each daysArray as day}
            {@const date = new Date(currentDate.getFullYear(), currentDate.getMonth(), day)}
            <button 
              type="button"
              class="calendar-day" 
              class:selected={selectedDate && formatDate(selectedDate) === formatDate(date)}
              class:disabled={isDateDisabled(date)}
              on:click|stopPropagation={() => selectDate(date)}
              on:keydown={(e) => handleDateKeydown(e, date)}
              disabled={isDateDisabled(date)}
            >
              {day}
            </button>
          {/each}
        </div>
      {/if}
    </div>
  {/if}
</div>

<style>
  .calendar-container {
    position: relative;
    width: 100%;
  }

  .calendar-input {
    cursor: pointer;
    outline: none;
  }

  .calendar-input:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.2);
    outline-offset: 2px;
  }

  .calendar-input input {
    width: 100%;
    height: 2.8rem;
    padding: 0 1rem;
    background: rgba(0, 0, 0, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 4px;
    color: white;
    font-size: 0.9rem;
    font-family: 'Poppins', sans-serif;
    cursor: pointer;
    box-sizing: border-box;
  }

  .calendar-dropdown {
    position: absolute;
    top: 100%;
    left: 0;
    right: 0;
    margin-top: 0.5rem;
    background: linear-gradient(to bottom, #1a1a1a, #000000);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 4px;
    padding: 1rem;
    z-index: 1000;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  }

  .calendar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
    color: white;
    padding: 0 0.5rem;
    gap: 0.5rem;
  }

  .header-selectors {
    display: flex;
    flex: 1;
    justify-content: center;
    gap: 2.3rem;
  }

  .month-year-btn {
    background: none;
    border: none;
    color: white;
    font-size: 0.9rem;
    cursor: pointer;
    padding: 0.25rem 1rem;
    border-radius: 4px;
    min-width: 110px;
    text-align: center;
    white-space: nowrap;
    font-weight: 500;
  }

  .month-year-btn:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .month-year-btn:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.2);
    outline-offset: 2px;
  }

  .calendar-header button {
    background: none;
    border: none;
    color: white;
    font-size: 1.2rem;
    cursor: pointer;
    padding: 0.5rem;
    border-radius: 4px;
    min-width: 32px;
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
  }

  .calendar-header button:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .calendar-header button:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.2);
    outline-offset: 2px;
  }

  .picker-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.5rem;
    max-height: 200px;
    overflow-y: auto;
    padding: 0.5rem;
    background: rgba(0, 0, 0, 0.2);
    border-radius: 4px;
  }

  .picker-item {
    background: none;
    border: none;
    color: white;
    font-size: 0.9rem;
    cursor: pointer;
    padding: 0.5rem;
    border-radius: 4px;
    text-align: center;
    min-width: 0;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
    font-weight: 500;
  }

  .picker-item:hover {
    background: rgba(255, 255, 255, 0.1);
  }

  .picker-item:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.2);
    outline-offset: 2px;
  }

  .picker-item.selected {
    background: rgba(255, 255, 255, 0.2);
  }

  .calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, minmax(0, 1fr));
    gap: 0.25rem;
    padding: 0.5rem;
    background: none;
    border-radius: 4px;
  }

  .calendar-day-header {
    text-align: center;
    font-size: 0.75rem;
    color: rgba(255, 255, 255, 0.7);
    padding: 0.25rem 0;
    font-weight: 500;
    min-width: 0;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }

  .calendar-day {
    background: none;
    border: none;
    text-align: center;
    padding: 0;
    cursor: pointer;
    border-radius: 4px;
    color: white;
    font-size: 0.9rem;
    width: 100%;
    aspect-ratio: 1;
    min-width: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 500;
  }

  .calendar-day:hover:not(:disabled) {
    background: rgba(255, 255, 255, 0.1);
  }

  .calendar-day:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.2);
    outline-offset: 2px;
  }

  .calendar-day.selected {
    background: rgba(255, 255, 255, 0.2);
  }

  .calendar-day:disabled {
    color: rgba(255, 255, 255, 0.3);
    cursor: not-allowed;
    background: none;
  }

  .calendar-day.empty {
    cursor: default;
    background: none;
  }

  /* Scrollbar styling */
  .picker-grid::-webkit-scrollbar {
    width: 6px;
  }

  .picker-grid::-webkit-scrollbar-track {
    background: rgba(0, 0, 0, 0.2);
    border-radius: 3px;
  }

  .picker-grid::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.2);
    border-radius: 3px;
  }

  .picker-grid::-webkit-scrollbar-thumb:hover {
    background: rgba(255, 255, 255, 0.3);
  }
</style> 