<script lang="ts">
  import CharacterSlot from './CharacterSlot.svelte';
  import { selectedCharacterId } from '../stores/selectedCharacter';
  import { useNuiEvent } from '../utils/useNuiEvent';
  import { fetchNui } from '../utils/fetchNui';

  interface Character {
    id: number;
    firstname: string;
    lastname: string;
    disabled?: boolean;
    skin?: any;
    sex: string;
    dateofbirth: string;
    job: string;
    job_grade: string;
    money: number;
    bank: number;
  }

  let visible = false;
  let characters: Character[] = [];
  let canCreate = false;
  let maxSlots = 0;


  useNuiEvent<{ characters: Character[], slots: number }>('openMenu', (data) => {
    if (!data) {
      return;
    }

    const validCharacters = Array.isArray(data.characters) 
      ? data.characters.filter(char => char !== null && typeof char === 'object')
      : [];
    
    visible = true;
    characters = validCharacters;
    maxSlots = data.slots;
    canCreate = characters.length < maxSlots;
    
    if ($selectedCharacterId !== null) {
      const characterExists = characters.some(char => char && char.id === $selectedCharacterId);
      if (!characterExists) {
        selectedCharacterId.set(null);
      }
    }
  });

  useNuiEvent('closeMenu', () => {
    visible = false;
    characters = [];
  });

  useNuiEvent('hideui', () => {
    visible = false;
    characters = [];
  });

  async function handleMenuAction(action: string, value?: any) {
    await fetchNui('menuAction', { action, value });
  }

  function handleDelete(id: number) {
    handleMenuAction('delete', id);
  }

  function handleCreate() {
    handleMenuAction('new');
  }

  function handleSelect(id: number) {
    handleMenuAction('select', id);
  }

  function handleReturn() {
    handleMenuAction('return');
  }
</script>

{#if visible}
<div class="container">
  <div class="sidebar">
    <div class="header">
      <div class="header-content">
        <div class="icon-container">
          <svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" viewBox="0 0 32 32">
            <path fill="currentColor" d="M30 23.5a4.5 4.5 0 0 1-4.5 4.5h-19A4.5 4.5 0 0 1 2 23.5v-15A4.5 4.5 0 0 1 6.5 4h19A4.5 4.5 0 0 1 30 8.5zm-2-15A2.5 2.5 0 0 0 25.5 6H12v5h16zm0 4.5H12v13h13.5a2.5 2.5 0 0 0 2.5-2.5z" />
          </svg>
        </div>
        <div class="header-text">
          <h1>Character Selection</h1>
          <p>Select and manage your active character</p>
        </div>
      </div>
    </div>
    <div class="character-list">
      {#each characters.filter(char => char !== null) as character, i (character?.id ?? i)}
        {#if character}
          <CharacterSlot 
            name={`${character.firstname} ${character.lastname}`}
            isActive={character.id === $selectedCharacterId}
            disabled={character.disabled ?? false}
            index={character.id}
            dob={character.dateofbirth}
            gender={character.sex}
            job={character.job}
            on:click={() => handleSelect(character.id)}
            on:delete={() => handleDelete(character.id)}
          />
        {/if}
      {/each}
    </div>
    {#if canCreate}
      <div class="create-button-container">
        <button class="create-button" on:click={handleCreate}>Create Character</button>
      </div>
    {/if}
  </div>
</div>
{/if}

<style>
  .container {
    position: absolute;
    top: 0;
    left: 0;
    width: 100vw;
    height: 100vh;
    display: flex;
    z-index: 1000;
    overflow: hidden;
  }

  .sidebar {
    width: 500px;
    height: 100vh;
    background: linear-gradient(to bottom, #1a1a1a, #000000);
    box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
    display: flex;
    flex-direction: column;
    overflow: hidden;
  }

  .header {
    padding: 20px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
    flex-shrink: 0;
  }

  .character-list {
    flex: 1;
    overflow-y: auto;
    padding: 8px 16px;
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .character-list::-webkit-scrollbar {
    width: 4px;
  }

  .character-list::-webkit-scrollbar-track {
    background: rgba(255, 255, 255, 0.05);
  }

  .character-list::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 2px;
  }

  .create-button-container {
    padding: 0 20px 20px 20px;
    display: flex;
    justify-content: center;
  }

  .create-button {
    width: 100%;
    padding: 12px;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 8px;
    color: rgba(255, 255, 255, 0.9);
    font-family: 'Poppins', sans-serif;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s ease;
  }

  .create-button:hover {
    background: rgba(255, 255, 255, 0.08);
    border-color: rgba(255, 255, 255, 0.15);
  }

  .header-content {
    display: flex;
    align-items: center;
    gap: 16px;
  }

  .header-text {
    color: white;
  }

  .header-text h1 {
    font-size: 22px;
    font-weight: 600;
    margin: 0;
    color: rgba(255, 255, 255, 0.9);
    font-family: 'Poppins', sans-serif;
  }

  .header-text p {
    font-size: 12px;
    margin: 2px 0 0 0;
    color: rgba(255, 255, 255, 0.5);
    font-family: 'Poppins', sans-serif;
  }

  .icon-container {
    width: 64px;
    height: 64px;
    border: 1px solid rgba(255, 255, 255, 0.1);
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: rgba(255, 255, 255, 0.9);
  }

  .icon-container svg {
    width: 32px;
    height: 32px;
  }
</style> 