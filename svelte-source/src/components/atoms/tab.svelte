<script lang="ts">
  export let name: string = "";
  export let active: boolean = false;
</script>

<div class="cursor-pointer bg-[#292929] rounded-lg p-[0.35rem] px-2">
  <p class="font-bold {active ? "border-b-3 border-[var(--ps-primary)]"
  :"hover:border-[var(--ps-primary-hover)] hover:border-b-3"}" on:click>
    {name}
  </p>
  <div></div>
</div>