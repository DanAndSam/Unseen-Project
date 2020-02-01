using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    private Animator animator;

    private void Awake()
    {
        animator = GetComponentInChildren<Animator>();
    }

    void Update()
    {

    }

    public void Attack()
    {
        if (animator != null)
        {
            animator.SetTrigger("StepOne");
        }
    }
}
