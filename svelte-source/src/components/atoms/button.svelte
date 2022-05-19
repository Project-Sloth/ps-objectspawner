<script lang="ts">
  export let name: string = "";
  export let buttonClass: string = "";
</script>

<button class="button bg-[var(--ps-primary)] text-base text-black hover:text-white py-2 px-4 my-2 rounded
  uppercase select-none {buttonClass} hover:bg-[var(--ps-primary-hover)] focus:ring-3 focus:ring-[#2bbca6]" on:click >
  <span class="py-3 font-bold">{name}</span>
</button>