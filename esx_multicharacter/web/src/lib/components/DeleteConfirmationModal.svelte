<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  
  export let characterName: string;
  export let isOpen: boolean = false;
  
  const dispatch = createEventDispatcher();
  let inputName = '';

  function handleDelete() {
    if (inputName.toLowerCase() === characterName.toLowerCase()) {
      dispatch('confirm');
      inputName = '';
    }
  }

  function handleCancel() {
    dispatch('cancel');
    inputName = '';
  }
</script>

{#if isOpen}
  <div 
    class="modal-backdrop" 
    on:click={e => e.target === e.currentTarget && handleCancel()}
    role="button"
    tabindex="0"
    on:keydown={e => e.key === 'Escape' && handleCancel()}
  >
    <div class="modal">
      <div class="modal-header">
        <h2>Delete Character</h2>
      </div>
      
      <div class="modal-content">
        <p class="warning">This action cannot be undone. Please type the character's name to confirm deletion.</p>
        
        <div class="input-group">
          <input 
            type="text" 
            bind:value={inputName}
            placeholder={`Type "${characterName}" to confirm`}
            class="name-input"
          />
        </div>
      </div>

      <div class="modal-footer">
        <button class="cancel-button" on:click={handleCancel}>Cancel</button>
        <button 
          class="delete-button" 
          on:click={handleDelete}
          disabled={inputName.toLowerCase() !== characterName.toLowerCase()}
        >
          Delete Character
        </button>
      </div>
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    background: rgba(0, 0, 0, 0.85);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    border: none;
    padding: 0;
    cursor: default;
  }

  .modal {
    background: linear-gradient(to bottom, #1a1a1a, #000000);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 8px;
    width: 520px;
    box-shadow: 0 4px 24px rgba(0, 0, 0, 0.5);
  }

  .modal-header {
    padding: 16px 24px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
  }

  .modal-header h2 {
    margin: 0;
    color: rgba(255, 255, 255, 0.9);
    font-family: 'Poppins', sans-serif;
    font-size: 18px;
    font-weight: 600;
  }

  .modal-content {
    padding: 20px 24px;
  }

  .warning {
    color: rgba(255, 255, 255, 0.6);
    font-family: 'Poppins', sans-serif;
    font-size: 13px;
    margin: 0 0 16px 0;
    line-height: 1.5;
  }

  .input-group {
    margin-bottom: 4px;
  }

  .name-input {
    width: 100%;
    box-sizing: border-box;
    padding: 12px;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    color: rgba(255, 255, 255, 0.9);
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
    transition: all 0.2s ease;
  }

  .name-input:focus {
    outline: none;
    border-color: rgba(255, 255, 255, 0.15);
    background: rgba(255, 255, 255, 0.03);
  }

  .name-input::placeholder {
    color: rgba(255, 255, 255, 0.3);
  }

  .modal-footer {
    padding: 16px 24px;
    border-top: 1px solid rgba(255, 255, 255, 0.08);
    display: flex;
    gap: 12px;
    justify-content: flex-end;
  }

  .cancel-button, .delete-button {
    padding: 8px 16px;
    border-radius: 6px;
    font-family: 'Poppins', sans-serif;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .cancel-button {
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.1);
    color: rgba(255, 255, 255, 0.7);
  }

  .cancel-button:hover {
    background: rgba(255, 255, 255, 0.04);
    border-color: rgba(255, 255, 255, 0.15);
  }

  .delete-button {
    background: rgba(255, 59, 48, 0.1);
    border: 1px solid rgba(255, 59, 48, 0.2);
    color: rgba(255, 59, 48, 0.9);
  }

  .delete-button:hover:not(:disabled) {
    background: rgba(255, 59, 48, 0.15);
    border-color: rgba(255, 59, 48, 0.25);
  }

  .delete-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
</style> 