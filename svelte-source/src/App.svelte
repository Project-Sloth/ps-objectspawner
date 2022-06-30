<script lang="ts">
  import { fade } from 'svelte/transition';
  import { EventHandler } from './utils/eventHandler';
  import ObjectStore from './stores/objectStore';
  import debug from './stores/debugStore';
  import Tab from './components/atoms/tab.svelte';
  import CreatePanel from './components/panels/create.svelte';
  import ManagePanel from './components/panels/manage.svelte';
  import { draggable } from '@neodrag/svelte';

  EventHandler();
  document.onkeyup = ObjectStore.handleKeyUp;

  interface tabType {
    name: string
    content: any
  }

  let { isOpen } = ObjectStore;
  let menuHandle;

  let tabArray: Array<tabType> = [
    { name: "Create", content: CreatePanel },
    { name: "Manage", content: ManagePanel },
  ];
  let activeTab: tabType = tabArray[0];

  function handleClick(index: number) {
    activeTab = tabArray[index];
  }
</script>

{#if $isOpen || debug}
  <main class="min-h-screen flex justify-center items-center {debug ? "bg-dark-300":""}" transition:fade="{{duration: 200}}">
    <div class="bg-dark-100 text-white w-[820px] h-[550px] p-5 text-lg rounded-lg shadow-xl my-auto font-semibold select-none"
      use:draggable={{ handle: menuHandle, bounds: 'body', gpuAcceleration: false, }}>
      <div class="drag-bar bg-dark-700 rounded-lg min-w-100 h-5 -mt-3 mb-2" bind:this={menuHandle}>
        <svg role="img" aria-label="drag handle" viewBox="0 0 24 24" height=24 width=24 class="mx-auto">
          <path
            fill="white"
            d="M3,15V13H5V15H3M3,11V9H5V11H3M7,15V13H9V15H7M7,11V9H9V11H7M11,15V13H13V15H11M11,11V9H13V11H11M15,15V13H17V15H15M15,11V9H17V11H15M19,15V13H21V15H19M19,11V9H21V11H19Z"
          />
        </svg>
      </div>
      <div class="flex flex-row gap-2 mb-5">
        {#each tabArray as tab, i}
          <Tab name={tab.name} on:click={() => handleClick(i)} active={tab.name == activeTab.name}/>
        {/each}
      </div>
      <div class="flex flex-col">
        {#each tabArray as tab}
          {#if activeTab.name == tab.name }
            <svelte:component this={tab.content}/>
          {/if}
        {/each}
      </div>
    </div>
  </main>
{/if}

<style>
  .drag-bar {
    user-select: none;
    cursor: grab;
	}
  .drag-bar:active {
    cursor: grabbing;
  }
	.drag-bar svg {
		opacity: 0.2;
		transition: opacity 0.2s;
	}
	.drag-bar:hover svg {
		opacity: 1;
	}
</style>
