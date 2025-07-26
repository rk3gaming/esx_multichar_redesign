import { writable } from 'svelte/store';
 
export const selectedCharacterId = writable<number | null>(null); 