<script lang="ts">
  import CharacterInfo from './CharacterInfo.svelte';
  import { selectedCharacterId } from '../stores/selectedCharacter';
  import { createEventDispatcher } from 'svelte';
  import { fetchNui } from '../utils/fetchNui';
  import DeleteConfirmationModal from './DeleteConfirmationModal.svelte';
  
  export let name: string;
  export let isActive: boolean;
  export let disabled: boolean;
  export let index: number;
  export let dob: string;
  export let gender: string;
  export let job: string;

  type ClickEvent = {
    index: number;
  };

  const dispatch = createEventDispatcher<{
    click: ClickEvent;
  }>();

  let showDeleteModal = false;
  let showInfo = false;

  $: showInfo = $selectedCharacterId === index;

  function toggleInfo() {
    if (name !== "Empty Slot") {
      const newId = $selectedCharacterId === index ? null : index;
      selectedCharacterId.set(newId);
      
      if (newId !== null) {
        fetchNui('menuAction', { action: 'select', value: newId });
      }
    }
  }

  function handleDelete() {
    showDeleteModal = true;
  }

  async function handleDeleteConfirm() {
    showDeleteModal = false;
    try {
      await fetchNui('menuAction', { action: 'delete', value: index });
    } catch (error) {
      console.error('Error deleting character:', error);
    }
  }

  function handleDeleteCancel() {
    showDeleteModal = false;
  }
</script>

<div class="slot-container">
  <button class="slot" class:selected={showInfo} on:click={toggleInfo}>
    <div class="slot-icon">
      {#if disabled}
        <div class="disabled-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M10 2h4c3.31 0 5 2.69 5 6v10.66C16.88 17.63 15.07 17 12 17s-4.88.63-7 1.66V8c0-3.31 1.69-6 5-6M8 8v1.5h8V8zm1 4v1.5h6V12zM3 22v-.69c2.66-1.69 10.23-5.47 18-.06V22z" />
          </svg>
        </div>
      {:else}
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2" />
          <circle cx="12" cy="7" r="4" />
        </svg>
      {/if}
    </div>
    <span class="slot-name">{name}</span>
  </button>
  {#if showInfo}
    <CharacterInfo {name} {dob} {gender} {job} {disabled} {index} on:delete={handleDelete} />
  {/if}
</div>

<DeleteConfirmationModal
  characterName={name}
  isOpen={showDeleteModal}
  on:confirm={handleDeleteConfirm}
  on:cancel={handleDeleteCancel}
/>

<style>
  .slot-container {
    transition: all 0.3s ease;
  }

  .slot {
    width: 100%;
    text-align: left;
    background: none;
    border: none;
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px 16px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.05);
    margin: 12px 0;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .slot:hover {
    background: rgba(255, 255, 255, 0.04);
    border-color: rgba(255, 255, 255, 0.1);
  }

  .slot.selected {
    background: rgba(255, 255, 255, 0.06);
    border-color: rgba(255, 255, 255, 0.15);
  }

  .slot-icon {
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: rgba(255, 255, 255, 0.5);
  }

  .slot-name {
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
    color: rgba(255, 255, 255, 0.7);
  }

  .selected .slot-name {
    color: rgba(255, 255, 255, 0.9);
  }
</style> 