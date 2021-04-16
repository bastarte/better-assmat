const loadForm = () => {
  const edit = document.getElementById("edit-comment");
  const assmatComment = document.getElementById("assmat-comment");
  const assmatForm = document.getElementById("assmat-form");
  console.log(edit);

  edit.addEventListener("click", (event) => {
  event.preventDefault();
  console.log(event);
  console.log(event.currentTarget);

  assmatComment.classList.toggle("hidden");
  assmatForm.classList.toggle("hidden");

  });
};

export { loadForm };
