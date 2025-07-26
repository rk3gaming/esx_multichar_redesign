<script lang="ts">
  import DeleteConfirmationModal from './DeleteConfirmationModal.svelte';
  import SpawnSelection from './SpawnSelection.svelte';
  import { createEventDispatcher } from 'svelte';
  import { fetchNui } from '../utils/fetchNui';

  export let dob: string = "01/01/1990";
  export let gender: string = "Male";
  export let job: string = "Unemployed";
  export let name: string = "Character Name";
  export let disabled: boolean = false;
  export let index: number;

  const dispatch = createEventDispatcher();
  let showDeleteModal = false;
  let showSpawnSelection = false;

  function handleDelete() {
    showDeleteModal = true;
  }

  function handleDeleteConfirm() {
    fetchNui('menuAction', { action: 'delete', value: index }).then(() => {
    showDeleteModal = false;
    }).catch(() => {
      console.error('Failed to delete character');
    });
  }

  function handleDeleteCancel() {
    showDeleteModal = false;
  }

  function handlePlay() {
    showSpawnSelection = true;
  }

  function handleSpawn(event: CustomEvent<{ location: string }>) {
    fetchNui('spawnAtLocation', { location: event.detail.location }).then(() => {
    showSpawnSelection = false;
    }).catch(() => {
      console.error('Failed to spawn character');
    });
  }

  function handleSpawnClose() {
    showSpawnSelection = false;
  }
</script>

<div class="info-box">
  <div class="info-grid">
    <div class="info-item-box">
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
        <path fill="currentColor" d="M21 20V6c0-1.103-.897-2-2-2h-2V2h-2v2H9V2H7v2H5c-1.103 0-2 .897-2 2v14c0 1.103.897 2 2 2h14c1.103 0 2-.897 2-2M9 18H7v-2h2zm0-4H7v-2h2zm4 4h-2v-2h2zm0-4h-2v-2h2zm4 4h-2v-2h2zm0-4h-2v-2h2zm2-5H5V7h14z" />
      </svg>
      <span>{dob}</span>
    </div>
    <div class="info-item-box">
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24">
        <path fill="currentColor" d="M19 2a3 3 0 0 1 2.995 2.824L22 5v14a3 3 0 0 1-2.824 2.995L19 22H5a3 3 0 0 1-2.995-2.824L2 19V5a3 3 0 0 1 2.824-2.995L5 2zm-7 9h-1l-.117.007a1 1 0 0 0 0 1.986L11 13v3l.007.117a1 1 0 0 0 .876.876L12 17h1l.117-.007a1 1 0 0 0 .876-.876L14 16l-.007-.117a1 1 0 0 0-.764-.857l-.112-.02L13 15v-3l-.007-.117a1 1 0 0 0-.876-.876zm.01-3l-.127.007a1 1 0 0 0 0 1.986L12 10l.127-.007a1 1 0 0 0 0-1.986z" />
      </svg>
      <span>{gender}</span>
    </div>
  </div>
  <div class="job-box">
    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 512 512">
      <path fill="currentColor" d="M336 288H176v-32H16v196a12 12 0 0 0 12 12h456a12 12 0 0 0 12-12V256H336Zm160-164a12 12 0 0 0-12-12H384V56a8 8 0 0 0-8-8H136a8 8 0 0 0-8 8v56H28a12 12 0 0 0-12 12v100h480Zm-152-12H168V88h176Z" />
    </svg>
    <span>{job}</span>
  </div>
  <div class="actions">
    {#if !disabled}
      <button class="action-button play" on:click={handlePlay}>
        <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
          <polygon points="5 3 19 12 5 21 5 3" />
        </svg>
        Play
      </button>
    {/if}
    <button class="action-button delete" on:click={handleDelete}>
      <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <polyline points="3 6 5 6 21 6" />
        <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
      </svg>
      Delete
    </button>
  </div>
</div>

<DeleteConfirmationModal 
  characterName={name}
  isOpen={showDeleteModal}
  on:confirm={handleDeleteConfirm}
  on:cancel={handleDeleteCancel}
/>

<SpawnSelection
  characterName={name}
  isOpen={showSpawnSelection}
  on:spawn={handleSpawn}
  on:close={handleSpawnClose}
/>

<style>
  .info-box {
    margin: 0 0 12px 0;
    padding: 20px;
    background: rgba(255, 255, 255, 0.03);
    border: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 8px;
  }

  .info-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 12px;
    margin-bottom: 12px;
  }

  .info-item-box {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    color: rgba(255, 255, 255, 0.7);
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
  }

  .info-item-box svg {
    color: rgba(255, 255, 255, 0.5);
  }

  .job-box {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 12px;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    color: rgba(255, 255, 255, 0.7);
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
    margin-bottom: 16px;
  }

  .job-box svg {
    color: rgba(255, 255, 255, 0.5);
  }

  .actions {
    display: flex;
    gap: 10px;
  }

  .action-button {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 8px;
    border-radius: 6px;
    font-family: 'Poppins', sans-serif;
    font-size: 13px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .action-button.play {
    background: rgba(46, 213, 115, 0.1);
    border: 1px solid rgba(46, 213, 115, 0.2);
    color: rgba(46, 213, 115, 0.9);
  }

  .action-button.play:hover {
    background: rgba(46, 213, 115, 0.15);
  }

  .action-button.delete {
    background: rgba(255, 59, 48, 0.1);
    border: 1px solid rgba(255, 59, 48, 0.2);
    color: rgba(255, 59, 48, 0.9);
  }

  .action-button.delete:hover {
    background: rgba(255, 59, 48, 0.15);
  }
</style> 