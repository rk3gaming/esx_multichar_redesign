<script lang="ts">
  import Calendar from './Calendar.svelte';
  import { useNuiEvent } from '../utils/useNuiEvent';
  import { fetchNui } from '../utils/fetchNui';
  
  export let hidden = true;
  
  let firstName = '';
  let lastName = '';
  let height = '';
  let birthday = '';
  let gender: 'm' | 'f' | null = null;
  let isVisible = false;
  let isSubmitting = false;

  const maleColor = '#3b82f6'; 
  const femaleColor = '#ec4899';

  useNuiEvent<{ visible: boolean }>('enableui', (data) => {
    isVisible = data.visible;
  });

  async function handleSubmit(event: Event) {
    event.preventDefault();
    
    if (isSubmitting) return;

    if (!firstName || !lastName || !height || !birthday || !gender) return;

    try {
      isSubmitting = true;
      const response = await fetchNui('register', {
        firstName,
        lastName,
        dateOfBirth: birthday,
        sex: gender,
        height: parseInt(height)
      });
    } catch (error) {
      console.error('Error during registration:', error);
    } finally {
      isSubmitting = false;
    }
  }
</script>

{#if isVisible}
  <div class="identity-box" style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%);">
    <div class="top-section">
      <div class="icon-container">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="-0.5 -0.5 24 24" style="transform: scale(1.3);">
          <path fill="#fff" d="m21.289.98l.59.59c.813.814.69 2.257-.277 3.223L9.435 16.96l-3.942 1.442c-.495.182-.977-.054-1.075-.525a.93.93 0 0 1 .045-.51l1.47-3.976L18.066 1.257c.967-.966 2.41-1.09 3.223-.276zM8.904 2.19a1 1 0 1 1 0 2h-4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-4a1 1 0 0 1 2 0v4a4 4 0 0 1-4 4h-12a4 4 0 0 1-4-4v-12a4 4 0 0 1 4-4z" />
        </svg>
      </div>
      <div class="text-content">
        <h1>Character Registration</h1>
        <p>Enter your character details to begin your journey.</p>
      </div>
    </div>
    <div class="divider"></div>
    <form class="form-section" on:submit={handleSubmit}>
      <div class="input-row">
        <div class="input-group">
          <label for="firstName">First Name</label>
          <input 
            type="text" 
            id="firstName" 
            bind:value={firstName} 
            placeholder="Enter first name"
            maxlength="16"
          />
        </div>
        <div class="input-group">
          <label for="lastName">Last Name</label>
          <input 
            type="text" 
            id="lastName" 
            bind:value={lastName} 
            placeholder="Enter last name"
            maxlength="16"
          />
        </div>
      </div>
      <div class="input-row">
        <div class="input-group">
          <label for="height">Height (cm)</label>
          <input 
            type="number" 
            id="height" 
            bind:value={height} 
            placeholder="Enter height"
            min="140"
            max="200"
          />
        </div>
        <div class="input-group">
          <label for="birthday">Date of Birth</label>
          <Calendar 
            bind:value={birthday}
            minAge={16}
          />
        </div>
      </div>
      <div class="input-row">
        <div class="input-group gender-group">
          <label>Gender</label>
          <div class="gender-buttons" role="radiogroup" aria-label="Select gender">
            <button 
              type="button"
              role="radio"
              aria-checked={gender === 'm'}
              class:selected={gender === 'm'}
              on:click={() => gender = 'm'}
              on:keydown={(e) => e.key === 'Enter' && (gender = 'm')}
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
                <path fill="currentColor" d="M20 4v6h-2V7.425l-3.975 3.95q.475.7.725 1.488T15 14.5q0 2.3-1.6 3.9T9.5 20t-3.9-1.6T4 14.5t1.6-3.9T9.5 9q.825 0 1.625.237t1.475.738L16.575 6H14V4zM9.5 11q-1.45 0-2.475 1.025T6 14.5t1.025 2.475T9.5 18t2.475-1.025T13 14.5t-1.025-2.475T9.5 11" />
              </svg>
              Male
            </button>
            <button 
              type="button"
              role="radio"
              aria-checked={gender === 'f'}
              class:selected={gender === 'f'}
              on:click={() => gender = 'f'}
              on:keydown={(e) => e.key === 'Enter' && (gender = 'f')}
            >
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
                <path fill="currentColor" d="M11 21v-2H9v-2h2v-2.1q-1.975-.35-3.238-1.888T6.5 9.45q0-2.275 1.613-3.862T12 4t3.888 1.588T17.5 9.45q0 2.025-1.263 3.563T13 14.9V17h2v2h-2v2zm1-8q1.45 0 2.475-1.025T15.5 9.5t-1.025-2.475T12 6T9.525 7.025T8.5 9.5t1.025 2.475T12 13" />
              </svg>
              Female
            </button>
          </div>
        </div>
      </div>
      <div class="input-row">
        <div class="input-group button-group">
          <button 
            type="submit"
            class="create-button"
            disabled={!firstName || !lastName || !height || !birthday || !gender || isSubmitting}
          >
            {isSubmitting ? 'Creating...' : 'Create Character'}
          </button>
        </div>
      </div>
    </form>
    <slot></slot>
  </div>
{/if}

<style>
  .identity-box {
    background: linear-gradient(to bottom, #1a1a1a, #000000);
    color: white;
    padding: 1.5rem 2rem 2rem 2rem;
    border-radius: 8px;
    width: 600px;
    height: 470px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.1);
    z-index: 1000;
  }

  .top-section {
    display: flex;
    align-items: flex-start;
    gap: 1.5rem;
    margin-bottom: 1.2rem;
  }

  .divider {
    height: 1px;
    background: rgba(255, 255, 255, 0.1);
    margin: 0 -2rem 1.2rem -2rem;
  }

  .form-section {
    padding: 0;
    display: flex;
    flex-direction: column;
    gap: 1.2rem;
  }

  .input-row {
    display: grid;
    grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
    gap: 1rem;
    width: 100%;
  }

  .input-group {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
    min-width: 0;
  }

  .input-group label {
    font-size: 0.85rem;
    color: rgba(255, 255, 255, 0.7);
    font-weight: 500;
  }

  .input-group input {
    width: 100%;
    height: 2.8rem;
    padding: 0 1rem;
    background: rgba(0, 0, 0, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 4px;
    color: white;
    font-size: 0.9rem;
    font-family: 'Poppins', sans-serif;
    transition: all 0.2s ease;
    box-sizing: border-box;
  }

  .input-group input[type="number"]::-webkit-inner-spin-button,
  .input-group input[type="number"]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
  }
  
  .input-group input::placeholder {
    color: rgba(255, 255, 255, 0.3);
  }

  .input-group input:focus {
    outline: none;
    border-color: rgba(255, 255, 255, 0.2);
    background: rgba(0, 0, 0, 0.3);
  }

  .icon-container {
    padding: 1.2rem;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 4px;
  }

  .icon-container svg {
    display: block;
  }

  .text-content {
    padding-top: 0;
  }

  .text-content h1 {
    font-size: 1.5rem;
    font-weight: 600;
    margin: 0 0 0.4rem 0;
    color: white;
  }

  .text-content p {
    margin: 0;
    color: rgba(255, 255, 255, 0.7);
    font-size: 0.9rem;
    line-height: 1.4;
  }

  .gender-group {
    grid-column: 1 / -1;
  }

  .gender-buttons {
    display: flex;
    gap: 1rem;
  }

  .gender-buttons button {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.75rem;
    height: 2.8rem;
    padding: 0 1.5rem;
    background: rgba(0, 0, 0, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 6px;
    color: white;
    font-size: 0.9rem;
    font-weight: 500;
    font-family: 'Poppins', sans-serif;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .gender-buttons button:hover {
    background: rgba(255, 255, 255, 0.1);
    transform: translateY(-1px);
  }

  .gender-buttons button:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.2);
    outline-offset: 2px;
  }

  .gender-buttons button.selected {
    border-color: transparent;
  }

  .gender-buttons button[aria-checked="true"]:first-child {
    background: #3b82f6;
    color: white;
  }

  .gender-buttons button[aria-checked="true"]:last-child {
    background: #ec4899;
    color: white;
  }

  .gender-buttons button svg {
    width: 20px;
    height: 20px;
  }

  .gender-buttons button[aria-checked="true"] svg {
    fill: white;
  }

  .button-group {
    grid-column: 1 / -1;
    margin-top: 1.5rem;
  }

  .create-button {
    width: 100%;
    height: 3rem;
    background: rgba(0, 0, 0, 0.2);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 4px;
    color: white;
    font-size: 1rem;
    font-weight: 500;
    font-family: 'Poppins', sans-serif;
    cursor: pointer;
    transition: all 0.2s ease;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
  }

  .create-button:hover {
    background: rgba(255, 255, 255, 0.1);
    border-color: rgba(255, 255, 255, 0.2);
    transform: translateY(-1px);
  }

  .create-button:active {
    transform: translateY(0);
    background: rgba(255, 255, 255, 0.15);
  }

  .create-button:focus-visible {
    outline: 2px solid rgba(255, 255, 255, 0.2);
    outline-offset: 2px;
  }

  .create-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
    transform: none;
  }

  .create-button:disabled:hover {
    background: rgba(0, 0, 0, 0.2);
    transform: none;
  }
</style> 